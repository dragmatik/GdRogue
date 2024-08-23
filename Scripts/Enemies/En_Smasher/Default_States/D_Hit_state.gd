extends Node

# Variables
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Imports
@onready var Body = $"../.."
@onready var animation = $"../../Animation"
@onready var attack_collider = $"../../Attack/Area/Collider"

func hit():
	# Hit state behavior
	attack_collider.disabled = true
	animation.play("hit")
	await animation.animation_finished
	if Body.enemy_is_dead:
		Body.current_state = Body.enemy_state.DEAD
	elif Body.body_in_attacker:
		Body.current_state = Body.enemy_state.ATTACK
	elif Body.vision:
		Body.current_state = Body.enemy_state.CHASE
	else:
		Body.current_state = Body.enemy_state.IDLE
