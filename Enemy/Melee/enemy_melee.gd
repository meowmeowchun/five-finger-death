extends CharacterBody2D

@export var speed = 200.0
@export var attack_range = 80.0 # Slightly larger than the stop distance
@export var stop_distance = 60.0 # How far from the player's center to stand

@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $Sprite2D
@onready var attack_timer = $AttackTimer

func _physics_process(_delta):
	if not player: return
	
	# 1. Calculate the Target Position (To the side of the player)
	var direction_to_player = sign(player.global_position.x - global_position.x)
	# If direction is 0 (rare), default to 1
	if direction_to_player == 0: direction_to_player = 1
	
	# The "Sweet Spot" is to the left or right of the player
	var target_pos = player.global_position
	target_pos.x -= (direction_to_player * stop_distance)

	# 2. Calculate vector to that specific target spot
	var vec_to_target = target_pos - global_position
	var distance_to_target = vec_to_target.length()

	# 3. State Logic
	if distance_to_target < 10.0: # If we are basically at the "Sweet Spot"
		velocity = Vector2.ZERO
		# Only attack if we are also lined up on the Y axis (the street depth)
		if abs(player.global_position.y - global_position.y) < 20:
			if attack_timer.is_stopped():
				attack()
	else:
		# Move toward the sweet spot, not the player's center
		velocity = vec_to_target.normalized() * speed
	
	# Add this inside _physics_process where you flip the sprite:
	if player.global_position.x < global_position.x:
		sprite.flip_h = true
		$PunchZone.position.x = -abs($PunchZone.position.x)
	else:
		sprite.flip_h = false
		$PunchZone.position.x = abs($PunchZone.position.x)
	if not player: return
	
	move_and_slide()

func attack():
	print("Enemy Attacks!")
	attack_timer.start(1.5)
	# (Insert your PunchZone check here)

func take_damage():
	print("Enemy hit!")
	# Add knockback
	velocity.x += 500 if player.global_position.x < global_position.x else -500
	
	# Simple hit flash or health reduction
	modulate = Color.RED # Turns the enemy red for a moment
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
