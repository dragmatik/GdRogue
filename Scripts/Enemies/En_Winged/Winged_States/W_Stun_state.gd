extends Node
 
# Stun variables
var is_stunned = false
var stun_duration = 2
var stun_scene = preload("res://Scenes/Effects/Textures/Stun.tscn")
var stun

# Imports
@onready var stun_timer = $Stun
@onready var Body = $"../.."
@onready var animation = $"../../Animation"
@onready var attack_cooldown = $"../Attack_state/Cooldown"

"""
func _on_area_area_entered(area):
	if area.name == "Shield":
		is_stunned = true
		Body.current_state = Body.enemy_state.STUN
		stun_timer.start(stun_duration)
		
		# Get stun effect
		stun = stun_scene.instantiate()
		get_parent().add_child(stun)
		stun.global_position = $"../../HP".global_position
"""

func stun_enemy():
	if is_stunned:
		animation.play("breathing")
	elif Body.enemy_is_dead:
		Body.current_state = Body.enemy_state.DEAD
	elif Body.body_in_attacker:
		Body.current_state = Body.enemy_state.ATTACK
	elif Body.vision:
		Body.current_state = Body.enemy_state.CHASE
	else:
		Body.current_state = Body.enemy_state.IDLE

func _on_stun_timeout():
	is_stunned = false
	stun.queue_free()
	$"../Attack_state".can_attack = false
	attack_cooldown.start(1)
