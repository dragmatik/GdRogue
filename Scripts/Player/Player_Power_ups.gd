extends Node2D

# Imports
@onready var health_node: Node2D = $"../HP"
@onready var body_node: Node2D = $".."
@onready var animation_node: AnimationPlayer = $"../Animation"
@onready var outline_node: AnimationPlayer = $"../Outline"
@onready var Ability_node: Node2D = $"../Ability"

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

# Abilities
func fire_ball_on() -> void:
	var scene: PackedScene = preload("res://Scenes/Skills/Fire_Ball.tscn")
	var get_scene: Node2D = scene.instantiate()
	add_child(get_scene)

func force_field_on() -> void:
	pass
