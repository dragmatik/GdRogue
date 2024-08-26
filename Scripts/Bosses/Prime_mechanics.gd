extends Node2D

# Imports
@onready var state_tree: AnimationTree = $"../State_tree"
@onready var state_machine: AnimationNodeStateMachinePlayback = state_tree["parameters/playback"]
@onready var parent_node: CharacterBody2D = $"../.."
@onready var body_node: CharacterBody2D = $".."
@onready var sprite_node: AnimatedSprite2D = $"../Sprite"
@onready var attack_collider_1: CollisionShape2D = $"../Attack/Area_1/Collider"
@onready var attack_collider_2: CollisionShape2D = $"../Attack/Area_2/Collider"

# Variables
var direction: float = 0

# Process
func _process(delta: float) -> void:
	if state_machine.is_playing():
		if state_machine.get_current_node() == "idle":
			stand(delta)
		elif state_machine.get_current_node() == "rush" or state_machine.get_current_node() == "rush_2":
			rush_attack()
		elif state_machine.get_current_node() == "chase":
			chase()

# Basics
func fall(delta: float) -> void:
	var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
	body_node.velocity.y += gravity * delta
	body_node.move_and_slide()

func stand(delta: float) -> void:
	if not body_node.is_on_floor():
		fall(delta)
	else:
		body_node.velocity = Vector2.ZERO

func defeat() -> void:
	attack_collider_1.disabled = true
	attack_collider_2.disabled = true

func death() -> void:
	parent_node.queue_free()

# Chase 
func chase() -> void:
	if body_node.player:
		direction = body_node.player.global_position.x - sprite_node.global_position.x
		body_node.velocity.x = direction * body_node.Speed
	# Determine facing direction and adjust animations
	if direction > 0:
		sprite_node.flip_h = false
		attack_collider_1.position.x = 29
		attack_collider_2.position.x = -25
	elif direction < 0:
		sprite_node.flip_h = true
		attack_collider_1.position.x = -29
		attack_collider_2.position.x = 25
	body_node.move_and_slide()

# Attacks
var can_rush: bool = false
func rush_frame(): # on rush frame
	can_rush = true

var target: float
func target_player(): # on first frame
	if body_node.player: 
		target = body_node.player.global_position.x

func rush() -> void: 
	if can_rush:
		direction = target - sprite_node.global_position.x
		body_node.velocity.x = direction * 6
		if direction > 0:
			sprite_node.flip_h = false
			attack_collider_1.position.x = 29
			attack_collider_2.position.x = -25
		elif direction < 0:
			sprite_node.flip_h = true
			attack_collider_1.position.x = -29
			attack_collider_2.position.x = 25
		body_node.move_and_slide()

func rush_attack() -> void:
	rush()

func finish_rush() -> void: 
	can_rush = false
