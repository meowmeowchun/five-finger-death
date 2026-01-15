extends Node

@export var shield_charges = 5
var is_defending = false

func _process(_delta):
	# Start defending: Only if we have charges and just pressed the key
	if Input.is_action_just_pressed("defend") and shield_charges > 0:
		shield_charges -= 1
		is_defending = true
		print("Shield Activated! Charges left: ", shield_charges)
	
	# Stop defending: When the key is released
	if Input.is_action_just_released("defend"):
		is_defending = false

@onready var anim = $"../AnimationPlayer"

func start_shielding():
	is_defending = true
	anim.play("shield") # Switch to your shield picture

func stop_shielding():
	is_defending = false
	anim.play("idle") # Go back to normal
