extends Node

# Imports
@onready var enemy_health: float = $"..".HEALTH
@onready var enemy_health_drop: float = $"..".HEALTH
@onready var body_node: Node2D = $".."
@onready var sprite = $"../Sprite" # dynamic typing (Sprite2D & Animatedsprite2D)
@onready var filter: AnimationPlayer = $"../Filter"
@onready var center_node: Node2D = $"../Collider"
@onready var health_bar_node: TextureProgressBar = $Health/Heath_bar
@onready var camera: Camera2D = $"../../../player/Camera"

# Variables
var damage_taken: float = 0

# Bleeding Variables
var bleeding: bool = false
var bleeding_duration: float = 2.0
var bleeding_elapsed_time: float = 0.0
var bleeding_interval: float = 0.1
var bleeding_timer: float = 0.0
var get_blood_scene: Node2D

# Thunder Variables
var thunder_on: bool = false
var thunder_frequency: float = 0.2
var thunder_timer: float = 0.0

# Bolt Variables
var bolt_on: bool = false
var bolt_frequency: float = 1.3
var bolt_timer: float = 0.0

# Preloads
var hit_scene: PackedScene = preload("res://Scenes/Effects/Textures/Hit_impact.tscn")
var claw_scene: PackedScene = preload("res://Scenes/Effects/Textures/Claw.tscn")
var blood_scene: PackedScene = preload("res://Scenes/Effects/Particles/Blood.tscn")
var thunder_scene: PackedScene = preload("res://Scenes/Skills/Ability_Thunder.tscn")
var bolt_scene: PackedScene = preload("res://Scenes/Skills/Ability_Thunder_2.tscn")

func _process(delta: float) -> void:
	# handle dynamic health decrease
	if enemy_health_drop > enemy_health:
		enemy_health_drop += (enemy_health - enemy_health_drop) * delta * 1.5
		if enemy_health_drop <= enemy_health:
			enemy_health_drop = enemy_health
	# Bleeding timer
	if bleeding:
		bleeding_timer += delta
		if bleeding_timer >= bleeding_interval:
			enemy_health -= SingletonBools.Bleed_damage
			health_bar_node.show_damage(SingletonBools.Bleed_damage, Color(1, 0, 0, 0.8), 20)
			bleeding_timer = 0.0
			bleeding_elapsed_time += bleeding_interval
			if bleeding_elapsed_time >= bleeding_duration:
				stop_bleeding()
	# Thunder strike timer
	if thunder_on:
		thunder_timer += delta
		if thunder_timer >= thunder_frequency:
			stop_thunder()
	# Thunder bolt timer
	if bolt_on:
		bolt_timer += delta
		if bolt_timer >= bolt_frequency:
			stop_bolt()

func handle_damage(area: Area2D) -> void:
	# Handle Base & Abilities damage
	match area.name:
		"Slash":
			apply_damage(SingletonBools.real_damage, Color(1, 1, 1, 1))
			create_impact_effect()
			# Handle special damage types
			if SingletonBools.Is_Bleed:
				start_bleeding_effect()
			if SingletonBools.Is_Thunder:
				start_thunder_effect()
			if SingletonBools.Is_Bolt:
				start_bolt_effect()
		"fire_ball_area":
			apply_damage(SingletonBools.Fire_ball_damage, Color(1, 1, 1, 1))

func apply_damage(damage_amount: float, color: Color) -> void:
	damage_taken = damage_amount
	enemy_health -= damage_taken
	# Display bigger number if Crit
	var fontsize: int
	if SingletonBools.is_crit: 
		fontsize = 30
		color = Color(1, 1, 0, 1) # Crit color
	else:
		fontsize = 20
	health_bar_node.show_damage(damage_taken, color, fontsize)
	# Shake camera and play filter effect
	camera.shake(5.0, 10.0)
	filter.play("Hit_effect")

func create_impact_effect() -> void:
	var get_hit: Node2D = hit_scene.instantiate()
	get_parent().add_child(get_hit)
	get_hit.impact(sprite.flip_h) # Flip if necessary
	get_hit.global_position = center_node.global_position

func start_bleeding_effect() -> void:
	if not bleeding:
		bleeding = true
		bleeding_elapsed_time = 0.0
		bleeding_timer = 0.0
		get_blood_scene = blood_scene.instantiate()
		get_parent().add_child(get_blood_scene)
		get_blood_scene.global_position = center_node.global_position
		get_blood_scene.scale = sprite.scale
		var get_claw: Node2D = claw_scene.instantiate()
		get_parent().add_child(get_claw)
		get_claw.global_position = center_node.global_position

func start_thunder_effect() -> void:
	if not thunder_on:
		thunder_on = true
		thunder_timer = 0.0 # Reset timer
		var get_thunder: Node2D = thunder_scene.instantiate()
		get_parent().add_child(get_thunder)
		get_thunder.global_position = center_node.global_position
		apply_damage(SingletonBools.Thunder_damage, Color(0.9, 0.9, 0.45, 1))

func start_bolt_effect() -> void:
	if not bolt_on:
		bolt_on = true
		bolt_timer = 0.0 # Reset timer
		var get_bolt: Node2D = bolt_scene.instantiate()
		get_parent().add_child(get_bolt)
		get_bolt.global_position = center_node.global_position

func stop_bleeding() -> void:
	get_blood_scene.queue_free()
	bleeding = false
	bleeding_elapsed_time = 0.0
	bleeding_timer = 0.0

func stop_thunder() -> void:
	thunder_on = false
	thunder_timer = 0.0

func stop_bolt() -> void:
	bolt_on = false
	bolt_timer = 0.0
	apply_damage(SingletonBools.Bolt_damage, Color(0.9, 0.9, 0.45, 1))
	# Apply reaction effect
	body_node.current_state = body_node.enemy_state.HIT
