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
		$Sprite2D.modulate = Color(0.5, 0.5, 1.0, 0.8) # Turn slightly blue/transparentd
	elif $DashComponent.is_dashing:
		velocity = direction.normalized() * $DashComponent.dash_speed
		$Sprite2D.modulate = Color.WHITE # Return to normal
	else:
		velocity = direction * speed
	# Inside player.gd _physics_process
	if $CombatComponent.is_attacking:
		velocity = velocity * 0.2 # Slow down significantly while punching
	move_and_slide()

func die():
	get_tree().reload_current_scene()

# Add 'attacker' inside the parentheses
func take_damage(_attacker):
	# 1. Check Dash
	if $DashComponent.is_dashing:
		return

	# 2. Check Shield (The Safe Zone)
	if $ShieldComponent.is_defending:
		print("Blocked by the Safe Zone!")
		return # ABSOLUTELY NOTHING HAPPENS. No charges lost here.

	# 3. Otherwise, die
	die()
