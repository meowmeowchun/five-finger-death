extends Node

@export var dash_speed = 1200.0
var is_dashing = false

func _process(_delta):
	if Input.is_action_just_pressed("dash") and $DashCooldown.is_stopped():
		is_dashing = true
		$DashTimer.start(0.2)
		$DashCooldown.start(1.0)
	
	if is_dashing and $DashTimer.is_stopped():
		is_dashing = false
