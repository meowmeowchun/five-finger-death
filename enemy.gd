extends CharacterBody2D

@export var speed = 200.0
@export var attack_range = 50.0

@onready var player = get_tree().get_first_node_in_group("player") # Make sure to add Player to "player" group!
@onready var sprite = $Sprite2D
@onready var attack_timer = $AttackTimer

func _physics_process(_delta):
	if not player: return
	
	# 1. Calculate distance to player
	var vec_to_player = player.global_position - global_position
	var distance = vec_to_player.length()
	
	# 2. State Logic: Attack or Follow
	if distance < attack_range:
		if attack_timer.is_stopped():
			attack()
	else:
		follow_player(vec_to_player)

	move_and_slide()

func follow_player(vec_to_player):
	# Normalize the direction so they don't move faster diagonally
	var direction = vec_to_player.normalized()
	velocity = direction * speed
	
	# Flip sprite to face player
	sprite.flip_h = direction.x < 0

func attack():
	velocity = Vector2.ZERO # Stop moving to punch
	print("Enemy Punches!")
	attack_timer.start(1.5) # Time between punches
	
	# Check if punch connects
	var targets = $PunchZone.get_overlapping_areas()
	for area in targets:
		if area.name == "Hurtbox": # We will add this to player next
			area.get_parent().take_damage()
