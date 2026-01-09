extends Node

@onready var player = get_parent()
@onready var hitbox_shape = $"../PunchHitbox/CollisionShape2D"
@onready var sprite = $"../Sprite2D"

var is_attacking = false

func _input(event):
	if event.is_action_pressed("punch") and not is_attacking:
		punch()

func punch():
	is_attacking = true
	
	# 1. Flip the hitbox based on which way the sprite is facing
	if sprite.flip_h:
		$"../PunchHitbox".position.x = -abs($'../PunchHitbox'.position.x)
	else:
		$"../PunchHitbox".position.x = abs($'../PunchHitbox'.position.x)

	# 2. Activate the hitbox
	hitbox_shape.disabled = false
	print("Player Punches!")

	# 3. Wait for the punch "active frames" to end
	await get_tree().create_timer(0.1).timeout
	hitbox_shape.disabled = true
	
	# 4. Recovery time (cooldown) before next punch
	await get_tree().create_timer(0.2).timeout
	is_attacking = false

# This function runs when the hitbox overlaps an enemy hurtbox
func _on_punch_hitbox_area_entered(area):
	if area.has_method("take_damage"):
		area.take_damage() # Or call a function on the enemy
