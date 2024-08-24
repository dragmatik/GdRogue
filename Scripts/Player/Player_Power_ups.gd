extends Node2D

# Imports
@onready var health_node: Node2D = $"../HP"
@onready var body_node: Node2D = $".."
@onready var animation_node: AnimationPlayer = $"../Animation"
@onready var outline_node: AnimationPlayer = $"../Outline"
@onready var Ability_node: Node2D = $"../Ability"
@onready var timer: Timer = $Ability_timer
@onready var emit_timer: Timer = $Emit_free

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

# Ability variables
var get_scene: Node2D
var Particles: GPUParticles2D

# Abilities
func fire_ball_on() -> void:
	var scene: PackedScene = preload("res://Scenes/Skills/Fire_Ball.tscn")
	get_scene = scene.instantiate()
	add_child(get_scene)
	Particles = get_scene.get_node("Particles")
	timer.start(Ability_node.current_ability.duration)
	emit_timer.start(Ability_node.current_ability.duration - 0.2)

func force_field_on() -> void:
	if Ability_node.current_ability.is_activated():
		outline_node.play("buff")
	else:
		outline_node.play("RESET")
		outline_node.stop()

func _on_ability_timer_timeout() -> void:
	get_scene.queue_free()

func _on_emit_free_timeout() -> void:
	if Particles:
		Particles.emitting = false
