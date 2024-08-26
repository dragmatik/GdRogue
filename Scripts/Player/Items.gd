extends Node2D

@onready var health_node: Node2D = $"../HP"
@onready var body_node: Node2D = $".."

# Upgrades
func _increase_max_hp_percentage() -> void:
	var hp_increase: float = 0.15
	health_node.MAX_HEALTH += health_node.MAX_HEALTH * hp_increase

func _recover_hp_value() -> void:
	var hp_recover: int = 50
	health_node.HEALTH += hp_recover

func _attack_up_percentage() -> void:
	SingletonBools.sharpner_counter += 1

func _speed_up_percentage() -> void:
	var speed_increase: float = 0.2
	var dust_frequency: float = 0.1
	body_node.SPEED += body_node.SPEED * speed_increase
	body_node.walk_interval -= body_node.walk_interval * dust_frequency
