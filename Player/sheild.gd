extends Node

@export var shield_charges = 5
var is_defending = false

@onready var anim = $"../AnimationPlayer"
@onready var player = get_parent()

func _process(_delta):
	# Start defending: Only if we have charges and just pressed the key
	if Input.is_action_just_pressed("defend") and shield_charges > 0:
		shield_charges -= 1
		is_defending = true
		anim.play("shield") # Switch to your shield picture
		player.set_collision_mask_value(3, false)
		player.set_collision_layer_value(2, false)
	
	# Stop defending: When the key is released
	if Input.is_action_just_released("defend"):
		is_defending = false
		player.set_collision_mask_value(3, true)
		player.set_collision_layer_value(2, true)
		anim.play("idle") # Go back to normal
