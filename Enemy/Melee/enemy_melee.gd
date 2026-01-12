extends CharacterBody2D

@export var speed = 150.0
@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $Sprite2D

var wander_offset = Vector2.ZERO
var wander_timer = 0.0
var is_hit = false # NEW: This stops the AI during knockback

func _physics_process(delta):
	if not player: return
	# 1. THE GATEKEEPER
	# If we are hit, skip all "chase" logic and just move with current velocity
	if is_hit:
		# Gradually slow down the knockback so they don't fly forever
		velocity = velocity.move_toward(Vector2.ZERO, speed * delta)
		move_and_slide()
		return # THIS IS KEY. It stops the rest of the code from running.

	# 2. CHASE LOGIC (Only runs if is_hit is false)
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
	move_and_slide()

func take_damage(attacker):
	# Ensure this 'print' is here so you can see it in the console!
	print("ENEMY SCRIPT: I HAVE BEEN HIT!") 
	if is_hit: return 
	is_hit = true
	var knock_dir = sign(global_position.x - attacker.global_position.x)
	if knock_dir == 0: knock_dir = 1
	velocity = Vector2(knock_dir * 1200, -300)
	modulate = Color.RED
	await get_tree().create_timer(0.4).timeout    
	is_hit = false
	modulate = Color.WHITE

func check_for_player_contact():
	# This uses the Area2D child of the enemy to check if it's touching the player
	var areas = $TouchArea.get_overlapping_areas()
	for area in areas:
		# If the thing we touch is a player hurtbox, kill the player
		if area.has_method("take_damage"):
			area.take_damage(self)
		elif area.get_parent().has_method("take_damage"):
			area.get_parent().take_damage(self)
