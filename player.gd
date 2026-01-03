extends CharacterBody2D

@export var speed = 500.0

func _physics_process(_delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Handle Sprite Flipping and Collision position
	if direction.x > 0:
		$Sprite2D.flip_h = false
		$Sprite2D.offset.x = -15.0
		$CollisionShape2D.position.x = 243
	elif direction.x < 0:
		$Sprite2D.flip_h = true
		$Sprite2D.offset.x = 15.0
		$CollisionShape2D.position.x = 304

	# Check with components before moving
	if $ShieldComponent.is_defending:
		velocity = Vector2.ZERO
	elif $DashComponent.is_dashing:
		velocity = direction.normalized() * $DashComponent.dash_speed
	else:
		velocity = direction * speed

	move_and_slide()

func die():
	get_tree().reload_current_scene()
