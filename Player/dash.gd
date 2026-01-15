extends Node

@export var dash_speed = 2000.0
var is_dashing = false

func _process(_delta):
	if Input.is_action_just_pressed("dash") and $DashCooldown.is_stopped():
		is_dashing = true
		$DashTimer.start(0.2)
		$DashCooldown.start(1.0)
	
	if is_dashing and $DashTimer.is_stopped():
		is_dashing = false
@onready var anim = $"../AnimationPlayer"

func start_dash():
	is_dashing = true
	anim.play("dash")
	
	# Wait for the dash time
	await get_tree().create_timer(0.8).timeout
	
	is_dashing = false
	anim.play("idle")
