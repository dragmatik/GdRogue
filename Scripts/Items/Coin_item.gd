extends Node

var orbit_radius: float = 0.0
var orbit_speed: float = 0.0
var sin_amplitude: float = 0.0
var sin_frequency: float = 0.0
var start_time: float = 0.0

var player: CharacterBody2D = null
var following: bool = false

func _ready() -> void:
	orbit_radius = randf_range(20, 50) # Increased range for further orbit
	orbit_speed = randf_range(0.5, 5)    # Adjusted speed range if needed
	sin_amplitude = randf_range(1, 5)  # Increased amplitude for sinusoidal movement
	sin_frequency = randf_range(1, 5)  # Frequency for the sinusoidal movement
	start_time = Time.get_ticks_msec() / 1000.0

func _process(delta: float) -> void:
	if not following:
		var t: float = (Time.get_ticks_msec() / 1000.0 - start_time) * orbit_speed
		self.position.x += sin(t) * orbit_radius * delta
		self.position.y += cos(t) * orbit_radius * delta + sin(t * sin_frequency) * sin_amplitude * delta
	else:
		if player:
			var direction: Vector2 = (player.global_position - self.global_position).normalized()
			self.global_position += direction * 100 * delta

func expire() -> void:
	queue_free()

func _on_collected_area_entered(_area: Area2D) -> void:
	$Animation.play("Collected")

func _on_detector_body_entered(body: CharacterBody2D) -> void:
	player = body
	$Timer.start(0.5)

func _on_detector_body_exited(_body: CharacterBody2D) -> void:
	player = null
	following = false

func _on_timer_timeout() -> void:
	if player:
		following = true
