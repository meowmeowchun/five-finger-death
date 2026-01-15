extends CharacterBody2D

@export var health = 3
@export var speed = 150.0
@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $Sprite2D

var wander_offset = Vector2.ZERO
var wander_timer = 0.0
var is_hit = false 

func _physics_process(delta):
	# 1. ENHANCED SAFETY CHECK
	if not is_inside_tree() or not player or health <= 0:
		return
	
	if is_hit:
		velocity = velocity.move_toward(Vector2.ZERO, speed * delta)
		# Only move if the physics space is still valid
		if is_inside_tree(): 
			move_and_slide()
		return

	# 2. CHASE LOGIC
	wander_timer -= delta
	if wander_timer <= 0:
		var random_angle = randf() * TAU 
		wander_offset = Vector2(cos(random_angle), sin(random_angle)) * 40
		wander_timer = randf_range(0.5, 1.2)

	var target_pos = player.global_position + wander_offset
	var direction = (target_pos - global_position).normalized()
	velocity = direction * speed
	sprite.flip_h = (player.global_position.x < global_position.x)
	
	check_for_player_contact()
	
	# 3. FINAL MOVEMENT SAFETY
	if is_inside_tree() and not is_queued_for_deletion():
		move_and_slide()

func take_damage(attacker):
	if is_hit or health <= 0: 
		return 
	
	health -= 1
	if health <= 0:
		die() 
		return

	is_hit = true
	var knock_dir = sign(global_position.x - attacker.global_position.x)
	if knock_dir == 0: knock_dir = 1
	
	velocity = Vector2(knock_dir * 1200, -300)
	modulate = Color.RED
	
	await get_tree().create_timer(0.4).timeout 
	
	# Check if we died during the timer
	if health > 0:
		is_hit = false
		modulate = Color.WHITE

func check_for_player_contact():
	if not is_inside_tree(): return
	var areas = $TouchArea.get_overlapping_areas()
	for area in areas:
		if area.has_method("take_damage"):
			area.take_damage(self)
		elif area.get_parent().has_method("take_damage"):
			area.get_parent().take_damage(self)
			
func die():
	# Stop everything immediately
	set_physics_process(false)
	set_process(false)
	
	# Disable hitbox safely
	$TouchArea/CollisionShape2D.set_deferred("disabled", true)
	
	# Visual effect
	modulate = Color(10, 10, 10, 1) 
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	
	# Connect to queue_free but check if still valid
	tween.finished.connect(func(): queue_free())
