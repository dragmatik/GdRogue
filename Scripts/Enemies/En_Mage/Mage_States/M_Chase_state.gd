extends Node

# Variables
var direction
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Imports
@onready var Body = $"../.."
@onready var speed = $"../..".SPEED
@onready var animation = $"../../Animation"
@onready var sprite = $"../../Sprite"
@onready var wall_raycast = $"../../Movement/Wall"
@onready var ground_raycast = $"../../Movement/Ground"
@onready var wall_raycast_position = $"../..".wall_raycast_position # Raycast Position
@onready var ground_raycast_position = $"../..".ground_raycast_position # Raycast Position

func chase(delta):
	# Movement state behavior
	if not Body.is_on_floor():
		Body.velocity.y += gravity * delta
		Body.move_and_slide()
	else:
		$"../..".ghost_maker(delta)
		direction = $"../..".player.global_position.x - sprite.global_position.x
		Body.velocity.x = direction * speed
		
		# Determine facing direction and adjust animations
		if direction > 0:
			sprite.flip_h = false  # Don't flip if moving right
			wall_raycast.rotation = deg_to_rad(-90)
			wall_raycast.position.x = wall_raycast_position
			ground_raycast.position.x = ground_raycast_position
		elif direction < 0:
			sprite.flip_h = true  # Flip if moving left
			wall_raycast.rotation = deg_to_rad(90)
			wall_raycast.position.x = -wall_raycast_position
			ground_raycast.position.x = -ground_raycast_position
		
		animation.play("run")
	
	Body.move_and_slide()
