extends Node
 
# Stun variables
var is_stunned = false
var stun_duration = 2
var stun_scene = preload("res://Scenes/VFX/Textures/Stun.tscn")
var stun

# Imports
@onready var stun_timer = $Stun
@onready var Body = $"../.."
@onready var animation = $"../../Animation"
@onready var attack_collider = $"../../Attack/Area/Collider"
@onready var attack_cooldown = $"../Attack_state/Cooldown"

func _on_area_area_entered(area):
	if area.name == "Shield":
		is_stunned = true
		Body.current_state = Body.enemy_state.STUN
		stun_timer.start(stun_duration)
		
		# Get stun effect
		stun = stun_scene.instantiate()
		get_parent().add_child(stun)
		stun.global_position = $"../../HP".global_position

var initial_position = 0

func stun_enemy():
	if is_stunned:
		attack_collider.disabled = true
		animation.play("breathing")
		# Slide the enemy backwards
		var target_position = 0
		if initial_position == 0:
			initial_position = Body.global_position.x
		if not $"../../Sprite".flip_h:
			target_position = initial_position - 25
		elif $"../../Sprite".flip_h:
			target_position = initial_position + 25
		else:
			pass
		$"../Chase_state".direction = target_position - $"../../Sprite".global_position.x
		Body.velocity.x = $"../Chase_state".direction * 5
		Body.move_and_slide()
		
	elif Body.enemy_is_dead:
		Body.current_state = Body.enemy_state.DEAD
	elif Body.body_in_attacker:
		Body.current_state = Body.enemy_state.ATTACK
	elif Body.vision:
		Body.current_state = Body.enemy_state.CHASE
	else:
		Body.current_state = Body.enemy_state.IDLE

func _on_stun_timeout():
	initial_position = 0
	is_stunned = false
	stun.queue_free()
	$"../Attack_state".can_attack = false
	attack_cooldown.start(1)
