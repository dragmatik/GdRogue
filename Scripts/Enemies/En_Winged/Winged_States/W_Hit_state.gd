extends Node

# Imports
@onready var Body = $"../.."
@onready var animation = $"../../Animation"

func hit():
	# Hit state behavior
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
