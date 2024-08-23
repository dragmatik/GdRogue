extends Node

# Variables
var path = 1
var is_idle = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Imports
@onready var idle_timer = $Turn_around
@onready var Body = $"../.."
@onready var idle_speed = $"../..".IDLE_SPEED
@onready var animation = $"../../Animation"
@onready var sprite = $"../../Sprite"
@onready var wall_raycast = $"../../Movement/Wall"
@onready var detection_collider = $"../../Detection/Collider"
@onready var projectile = $"../../Projectile"
@onready var wall_raycast_position = $"../..".wall_raycast_position # Raycast Position
@onready var detection_collider_position = $"../..".detection_collider_position # Collider Position
@onready var projectile_position = $"../..".projectile_position

func idle(delta):
	if is_idle:
		animation.play("idle")
		return
		
	if $"../../Height".is_colliding():
		Body.velocity.y += -gravity * delta
		Body.velocity.x = 0
		Body.move_and_slide()
	else:
		Body.velocity.y = 0
		Body.velocity.x = path * idle_speed
		animation.play("run")
		
	if wall_raycast.is_colliding():
		is_idle = true
		idle_timer.start(2)
		
	if path > 0:
		sprite.flip_h = false  # Don't flip if moving right
		wall_raycast.rotation = deg_to_rad(-90)
		wall_raycast.position.x = wall_raycast_position
		detection_collider.position.x = detection_collider_position
		projectile.position.x = projectile_position
	elif path < 0:
		sprite.flip_h = true  # Flip if moving left
		wall_raycast.rotation = deg_to_rad(90)
		wall_raycast.position.x = -wall_raycast_position
		detection_collider.position.x = -detection_collider_position
		projectile.position.x = -projectile_position
			
	Body.position.y += sin(Time.get_ticks_msec() / 1000.0 * 2.0 * PI) * 0.5
	Body.move_and_slide()

func _on_turn_around_timeout():
	if wall_raycast.is_colliding():
		path *= -1
	is_idle = false
