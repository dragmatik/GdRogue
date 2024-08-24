extends Node2D

# Variables for controlling the orbit
@export var center: Vector2 = Vector2(0, 0)
@export var orbit_distance: float
@export var orbit_speed: float

# Internal angle variable
var current_angle: float = 0.0

func _process(delta: float) -> void:
	# Update the angle based on the orbit speed and delta time
	current_angle += orbit_speed * delta

	# Calculate the new position based on the angle and orbit distance
	var new_position = Vector2(cos(current_angle), sin(current_angle)) * orbit_distance + center

	# Set the position of the Node2D
	position = new_position
