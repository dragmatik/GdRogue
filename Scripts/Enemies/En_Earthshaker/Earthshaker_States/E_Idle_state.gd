extends Node

# Variables
var path = 1
var is_idle = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Imports
@onready var idle_timer = $Turn_around
@onready var Body = $"../.."
@onready var speed = $"../..".SPEED
@onready var idle_speed = $"../..".IDLE_SPEED
@onready var animation = $"../../Animation"
@onready var sprite = $"../../Sprite"
@onready var wall_raycast = $"../../Movement/Wall"
@onready var ground_raycast = $"../../Movement/Ground"
@onready var detection_collider = $"../../Detection/Collider"
@onready var rock = $"../../Rock"
@onready var wall_raycast_position = $"../..".wall_raycast_position # Raycast Position
@onready var ground_raycast_position = $"../..".ground_raycast_position # Raycast Position
@onready var detection_collider_position = $"../..".detection_collider_position # Collider Position
@onready var rock_position = $"../..".rock_position

func idle(delta):
	if is_idle:
		animation.play("idle")
		return
		
	if not Body.is_on_floor():
		Body.velocity.y += gravity * delta
		Body.move_and_slide()
	else:
		Body.velocity.y = 0
		Body.velocity.x = path * speed * idle_speed
		
		if wall_raycast.is_colliding() or not ground_raycast.is_colliding():
			is_idle = true
			idle_timer.start(2)
		
		if path > 0:
			sprite.flip_h = false  # Don't flip if moving right
			wall_raycast.rotation = deg_to_rad(-90)
			wall_raycast.position.x = wall_raycast_position
			ground_raycast.position.x = ground_raycast_position
			detection_collider.position.x = detection_collider_position
			rock.position.x = rock_position
		elif path < 0:
			sprite.flip_h = true  # Flip if moving left
			wall_raycast.rotation = deg_to_rad(90)
			wall_raycast.position.x = -wall_raycast_position
			ground_raycast.position.x = -ground_raycast_position
			detection_collider.position.x = -detection_collider_position
			rock.position.x = -rock_position
			
		animation.play("run")
	Body.move_and_slide()

func _on_turn_around_timeout():
	if wall_raycast.is_colliding() or not ground_raycast.is_colliding():
		path *= -1
	is_idle = false
