extends CharacterBody2D

@export var speed = 500.0
@onready var anim = $AnimationPlayer # Make sure the node name matches exactly!

func _physics_process(_delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if direction.x > 0:
		$Sprite2D.flip_h = false
	elif direction.x < 0:
		$Sprite2D.flip_h = true

	if $ShieldComponent.is_defending:
		velocity = Vector2.ZERO
	elif $DashComponent.is_dashing:
		velocity = direction.normalized() * $DashComponent.dash_speed
	else:
		velocity = direction * speed

	if $CombatComponent.is_attacking:
		velocity = velocity * 0.2 
	
	move_and_slide()

func _process(_delta):
	# 1. PRIORITY ANIMATIONS (Shield and Dash)
	if $ShieldComponent.is_defending:
		anim.play("shield") # Plays the shielding picture
		return
	
	if $DashComponent.is_dashing:
		anim.play("dash") # Plays the dash animation
		return
	
	if $CombatComponent.is_attacking:
		anim.play("punch")
		return

	# 2. MOVEMENT ANIMATIONS (Idle and Walk)
	if velocity.length() > 0:
		anim.play("idle")
	else:
		anim.play("idle")

func die():
	get_tree().reload_current_scene()

func take_damage(_attacker):
	if $DashComponent.is_dashing:
		return
	if $ShieldComponent.is_defending:
		print("Blocked by the Safe Zone!")
		return
	die()
