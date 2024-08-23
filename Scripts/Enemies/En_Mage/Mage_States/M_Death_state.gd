extends Node

# Variables
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Imports
@onready var Enemy = $"../../.."
@onready var Body = $"../.."
@onready var animation = $"../../Animation"
@onready var hitbox = $"../../Hitbox/Collider"

func death(delta):
	if not Body.is_on_floor():
		Body.velocity.y += gravity * delta
		Body.move_and_slide()
	# Death state behavior
	hitbox.disabled = true
	animation.play("death")
	await animation.animation_finished  # Wait for death animation to finish
	Enemy.queue_free()  # Free the enemy node from the scene
