extends CharacterBody2D

@export var speed = 500.0

func _physics_process(_delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Handle Sprite Flipping and Collision position
	if direction.x > 0:
		$Sprite2D.flip_h = false
	elif direction.x < 0:
		$Sprite2D.flip_h = true

	# Check with components before moving
	if $ShieldComponent.is_defending:
		velocity = Vector2.ZERO
	elif $DashComponent.is_dashing:
		velocity = direction.normalized() * $DashComponent.dash_speed
	else:
		velocity = direction * speed
	# Inside player.gd _physics_process
	if $CombatComponent.is_attacking:
		velocity = velocity * 0.2 # Slow down significantly while punching
	move_and_slide()

func die():
	get_tree().reload_current_scene()

func take_damage():
	if $DashComponent.is_dashing:
		return # Invincible!
	if $ShieldComponent.is_defending:
		$ShieldComponent.shield_durability -= 25
		return
	
	die() # From your previous script
