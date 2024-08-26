extends Node2D

# Imports
@onready var outline_node: AnimationPlayer = $"../Effects/Outline_effect"
@onready var Ability_node: Node2D = $"../Get_abilities"
@onready var timer: Timer = $Ability_timer
@onready var emit_timer: Timer = $Emit_free

# Variables
var get_scene: Node2D
var Particles: GPUParticles2D

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
