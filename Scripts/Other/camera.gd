extends Camera2D

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var shake_strength: float = 0.0
var shakeFade: float = 0.0

# Zoom settings
var zoom_factor: float = 1.0
var zoom_speed: float = 5.0

func _process(delta: float) -> void:
	var player_pos: Vector2 = $"..".global_position
	# Update the camera's global position
	global_position = player_pos
	
	# Apply the shake effect if shake strength is greater than 0
	if shake_strength > 0.0:
		shake_strength = lerp(shake_strength, 0.0, shakeFade * delta)
		global_position += randomOffset()
	
	# Adjust zoom based on character movement
	var velocity: Vector2 = $"..".velocity  # Assuming the player node has a velocity property
	if velocity.length() > 0:
		zoom_factor = lerp(zoom_factor, 3.2, zoom_speed * delta)  # Zoom in
	else:
		zoom_factor = lerp(zoom_factor, 3.5, zoom_speed * delta)  # Zoom out
	zoom = Vector2(zoom_factor, zoom_factor)

func shake(intensity: float, fade: float) -> void:
	shake_strength = intensity
	shakeFade = fade

func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
