extends Node

# Variables
var can_attack = true

# Imports
@onready var attack_cooldown = $"../..".ATTACK_COOLDOWN
@onready var cooldown_timer = $Cooldown
@onready var Body = $"../.."
@onready var animation = $"../../Animation"

func attack():
	# Attack state behavior
	if can_attack:
		animation.play("attack")
		if $"../..".player: # Update the player position even during the attack animation
			$"../..".player_pos = $"../..".player.global_position
		await animation.animation_finished
		can_attack = false
		cooldown_timer.start(attack_cooldown)
	else:
		animation.play("idle")
	
	if $"../..".player:
		$"../..".player_pos = $"../..".player.global_position

func _on_cooldown_timeout():
	can_attack = true
