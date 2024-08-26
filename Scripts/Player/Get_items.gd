extends Node

@onready var Upgrades_node: Node2D = $"../Items"

# Bools
var health_recover: bool = false
var attack_increase: bool = false

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_interact"):
		if health_recover:
			Upgrades_node._recover_hp_value()
		elif attack_increase:
			Upgrades_node._attack_up_percentage()

func _on_collector_area_entered(area: Area2D) -> void:
	if area.name == "Coin":
		SingletonBools.Coins += 10
	if area.name == "health_recover":
		health_recover = true
	elif area.name == "attack_increase":
		attack_increase = true

func _on_collector_area_exited(area: Area2D) -> void:
	if area.name == "health_recover":
		health_recover = false
	elif area.name == "attack_increase":
		attack_increase = false
