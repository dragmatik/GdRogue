extends CharacterBody2D

# Variables
const HEALTH: float = 1000
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

# Imports
@onready var animation_node: AnimationPlayer = $Animation
@onready var health_node: Node2D = $HP

# States
enum enemy_state {IDLE, HIT}
var current_state: enemy_state = enemy_state.IDLE

func _physics_process(delta: float) -> void:
	match current_state:
		enemy_state.IDLE:
			idle_enemy(delta)
		enemy_state.HIT:
			hit_enemy()

func idle_enemy(delta: float) -> void:
	animation_node.play("RESET")
	if not is_on_floor():
		velocity.y += gravity * delta
		move_and_slide()
	else:
		velocity = Vector2(0, 0)

func hit_enemy() -> void:
	animation_node.play("en_hit")
	await animation_node.animation_finished
	current_state = enemy_state.IDLE

func _on_hitbox_area_entered(area: Area2D) -> void:
	# Handle damage
	health_node.handle_damage(area)
	current_state = enemy_state.HIT
	if health_node.enemy_health <= 0:
		health_node.enemy_health = 1000
		health_node.enemy_health_drop = 1000
