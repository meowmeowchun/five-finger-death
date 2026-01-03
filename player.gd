extends CharacterBody2D

@export var speed = 500.0
@export var camera_smooth_speed = 0.3

# --- SHAKE SETTINGS ---
@export var shake_intensity = 3.0  
@export var shake_speed = 30.0      
var noise_time = 1.0                

# --- THE FIX: Move target_x here so it is "remembered" ---
var last_target_x = 0.0

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	
	var screen_size = get_viewport_rect().size
	
	# 1. Update the target ONLY when there is horizontal movement
	if direction.x > 0:
		$Sprite2D.flip_h = false
		$Sprite2D.offset.x = -15.0
		$CollisionShape2D.position.x = 243 # Move to positive side
		last_target_x = 0.0 # Position for moving right
	elif direction.x < 0:
		$Sprite2D.flip_h = true
		$Sprite2D.offset.x = 15.0
		last_target_x = -screen_size.x * 0.7 # Position for moving left
		$CollisionShape2D.position.x = 302 # Move to positive side
	# If direction.x is 0, we simply DON'T update last_target_x, so it stays where it was!

	var base_y_offset = -screen_size.y * 0.4 
	
	# 2. Calculate Shake
	var shake_vec = Vector2.ZERO
	if direction.length() > 0:
		noise_time += delta * shake_speed
		shake_vec.x = sin(noise_time) * shake_intensity
		shake_vec.y = cos(noise_time * 1.5) * shake_intensity

	# 3. Apply to Camera using the "remembered" target
	$Camera2D.offset.x = lerp($Camera2D.offset.x, last_target_x, camera_smooth_speed) + shake_vec.x
	$Camera2D.offset.y = base_y_offset + shake_vec.y

	move_and_slide()
