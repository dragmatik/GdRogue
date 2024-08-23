extends Node

# Variables
var direction

# Imports
@onready var Body = $"../.."
@onready var speed = $"../..".SPEED
@onready var animation = $"../../Animation"
@onready var sprite = $"../../Sprite"
@onready var wall_raycast = $"../../Movement/Wall"
@onready var detection_collider = $"../../Detection/Collider"
@onready var projectile = $"../../Projectile"
@onready var wall_raycast_position = $"../..".wall_raycast_position # Raycast Position
@onready var detection_collider_position = $"../..".detection_collider_position # Collider Position
@onready var projectile_position = $"../..".projectile_position

func chase(delta):
	# Movement state behavior
	if $"../..".player:
		$"../..".ghost_maker(delta)
		$"../..".player_pos = $"../..".player.global_position
		direction = ($"../..".player_pos - $"../..".global_position).normalized()
		$"../..".velocity = direction * speed
		
		# Determine facing direction and adjust animations
		if direction.x > 0:
			sprite.flip_h = false  # Don't flip if moving right
			wall_raycast.rotation = deg_to_rad(-90)
			wall_raycast.position.x = wall_raycast_position
			detection_collider.position.x = detection_collider_position
			projectile.position.x = projectile_position
		elif direction.x < 0:
			sprite.flip_h = true  # Flip if moving left
			wall_raycast.rotation = deg_to_rad(90)
			wall_raycast.position.x = -wall_raycast_position
			detection_collider.position.x = -detection_collider_position
			projectile.position.x = -projectile_position
		
		animation.play("run")
	
	Body.move_and_slide()
