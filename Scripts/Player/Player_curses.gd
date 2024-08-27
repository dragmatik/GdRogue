extends Node

# imports
@onready var health_node: Node2D = $"../HP"

# Bleeding Variables
var bleeding: bool = false
var bleeding_duration: float = 2.0
var bleeding_elapsed_time: float = 0.0
var bleeding_interval: float = 0.1
var bleeding_timer: float = 0.0
var get_blood_scene: Node2D

# Preloads
var Claw: PackedScene = preload("res://Scenes/VFX/Textures/Claw.tscn")
var Blood: PackedScene = preload("res://Scenes/VFX/Particles/Blood.tscn")

func _process(delta: float) -> void:
	# Handle bleeding effect
	if bleeding:
		bleeding_timer += delta
		if bleeding_timer >= bleeding_interval:
			health_node.HEALTH -= 0.5
			bleeding_timer = 0.0
			bleeding_elapsed_time += bleeding_interval
			if bleeding_elapsed_time >= bleeding_duration:
				stop_bleeding()

func handle_curses(_value: float, value_name: String) -> void:
	if value_name == "bleeding_damage":
		if not bleeding:
			bleeding = true
			get_blood_scene = Blood.instantiate() # show particle effect
			get_parent().add_child(get_blood_scene)
			var get_claw: Node2D = Claw.instantiate() # show particle effect
			get_parent().add_child(get_claw)
			bleeding_elapsed_time = 0.0
			bleeding_timer = 0.0

func stop_bleeding() -> void:
	get_blood_scene.queue_free()
	bleeding = false
	bleeding_elapsed_time = 0.0
	bleeding_timer = 0.0
