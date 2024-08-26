extends CharacterBody2D

# Imports
@onready var state_tree: AnimationTree = $State_tree
@onready var state_machine: AnimationNodeStateMachinePlayback = state_tree["parameters/playback"]
@onready var health_node: Node2D = $HP
@onready var attack_collider_1: CollisionShape2D = $Attack/Area_1/Collider
@onready var attack_collider_2: CollisionShape2D = $Attack/Area_2/Collider
@onready var Idle_timer: Timer = $Timers/Idle
@onready var Cast_timer: Timer = $Timers/Cast

# Constants
const HEALTH: int = 10000
const Speed: float = 1.35

# Variables
var player: CharacterBody2D 

# Conditions
var can_attack: bool = false
var can_cast: bool = false
var is_detected: bool = false
const rush: Array = ["rush"]
const defeat: Array = ["death"]
const slash: Array = ["slash"]
const attacks: Array = ["cast", "ready", "chase"]
const casts: Array = ["power_up", "cancel"]

func _ready() -> void:
	attack_collider_1.disabled = true
	attack_collider_2.disabled = true

#### Start an attack ####

func start_attack() -> void:
	state_machine.travel(attacks.pick_random())

func idle_timer() -> void:
	if not can_attack:
		Idle_timer.start(1.5)
		can_attack = true

func _on_idle_timeout() -> void:
	start_attack()

func set_attack_false() -> void:
	can_attack = false

#### Rush attack ####

func rush_attack() -> void:
	state_machine.travel(rush.pick_random())

#### Slash ####

func slash_attack() -> void:
	if is_detected:
		state_machine.travel(slash.pick_random())

#### Hold cast ####

func cast_attack() -> void:
	state_machine.travel(casts.pick_random())

func cast_timer() -> void:
	if not can_cast:
		Cast_timer.start(1.85)
		can_cast = true

func _on_cast_timeout() -> void:
	cast_attack()

func set_cast_false() -> void:
	can_cast = false

#### Detect the player ####

func _on_vision_det_body_entered(body: CharacterBody2D) -> void:
	player = body

func _on_vision_det_body_exited(_body: CharacterBody2D) -> void:
	player = null

func _on_detect_body_entered(_body: CharacterBody2D) -> void:
	is_detected = true

func _on_detect_body_exited(_body: CharacterBody2D) -> void:
	is_detected = false

func _on_hitbox_area_entered(area: Area2D) -> void:
	health_node.handle_damage(area)
	if health_node.enemy_health <= 0:
		state_machine.travel(defeat.pick_random())
	elif health_node.enemy_health <= HEALTH * 0.5:
		print("Phase 2")
