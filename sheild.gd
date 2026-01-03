extends Node

@export var shield_durability = 100.0
var is_defending = false

func _process(_delta):
	if Input.is_action_pressed("defend") and shield_durability > 0:
		is_defending = true
		shield_durability -= 0.5
	else:
		is_defending = false
		if shield_durability < 100:
			shield_durability += 0.1
