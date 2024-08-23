extends Node

# Imports
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var body_node: Node2D = $".."
@onready var player_sprite: Sprite2D = $"../Sprite"
@onready var player_animation: AnimationPlayer = $"../Animation"
@onready var weapon_sprite: Sprite2D = $"../Equipment/Weapon"
@onready var weapon_animation: AnimationPlayer = $"../Equipment/Weapon_animation"
@onready var combo_timer: Timer = $Combo_reset
@onready var attack_area: Area2D = $Slash
@onready var block_area: Area2D = $"../Blocking/Shield"
@onready var block_node: Node2D = $"../Blocking"
@onready var hanger: Area2D = $"../Hanger"

# Equipment loading
@export var current_equipment: Equipment
@onready var basic_sword: Equipment = preload("res://Resources/Equipment/Basic_sword.tres")
@onready var golden_sword: Equipment = preload("res://Resources/Equipment/Golden_sword.tres")

# Attack variables
var is_attacking: bool = false
var combo_step: int = -1
var air_combo_step: int = -1
var reset_combo: float = 0.6

# Crit damage handler
var real_damage: float = 0 # store base damage before crit
var crit_damage: float = 0 # critical value of base damage

func _ready() -> void:
	current_equipment = basic_sword
	SingletonBools.Base_damage = current_equipment.damage
	$Slash/Collider.disabled = true

func _process(_delta: float) -> void:
	# Check if attack button is pressed
	if Input.is_action_pressed("ui_slash") and not block_node.is_blocking:
		if not is_attacking:
			
			# reset slide and dash if they had been cut
			body_node.is_dashing = false
			body_node.is_sliding = false
			
			body_node.current_state = body_node.player_state.ATTACK
			is_attacking = true # set to false in reset state and hang state
			combo_step += 1
			air_combo_step += 1
			combo_timer.start(reset_combo)

func _on_combo_reset_timeout() -> void:
	combo_step = -1
	air_combo_step = -1
	is_attacking = false

func attack(delta: float) -> void:
	# Set current equipment texture
	weapon_sprite.texture = current_equipment.texture
	# Attack animation handler
	if body_node.is_on_floor():
		weapon_sprite.visible = true
		# Handle attack animations based on combo step
		if combo_step == 0:
			player_animation.play(current_equipment.animation + "_1")
			weapon_animation.play(current_equipment.animation + "_1")
		elif combo_step == 1:
			player_animation.play(current_equipment.animation + "_2")
			weapon_animation.play(current_equipment.animation + "_2")
		elif combo_step == 2:
			player_animation.play(current_equipment.animation + "_3")
			weapon_animation.play(current_equipment.animation + "_3")
		elif combo_step > 2:
			combo_step = 0
	else:
		# Handle air attack animations based on combo step
		if air_combo_step == 0:
			player_animation.play("air_attack_1")
		elif air_combo_step == 1:
			player_animation.play("air_attack_2")
		elif air_combo_step > 1:
			air_combo_step = 0
		body_node.velocity.y += (gravity - 500) * delta # more air duration = better feeling
		body_node.velocity.x *= 0.5 # more precise air attack (fix bug to limit dash attack speed)
		body_node.move_and_slide()
		
	# Better directonal attack control (ground and air)
	var direction: float = Input.get_axis("ui_left", "ui_right")
	if direction > 0:
		hanger.position.x = 18
		player_sprite.flip_h = false  # Don't flip the sprite when moving right
		weapon_sprite.flip_h = false
		attack_area.position.x = 37
		block_area.position.x = 15
	elif direction < 0:
		hanger.position.x = -18
		player_sprite.flip_h = true  # Don't flip the sprite when moving right
		weapon_sprite.flip_h = true
		attack_area.position.x = -37
		block_area.position.x = -15
	else: # Set previous direction
		pass

func critical_chance() -> void:
	SingletonBools.real_damage = SingletonBools.calculate_damage()
	real_damage = SingletonBools.real_damage
	# Roll for critical hit
	if randf() < SingletonBools.crit_rate: # randf picks a random float between 0 and 1
		SingletonBools.is_crit = true
		var multiply: float = randf_range(2.0, 3.0)
		crit_damage = real_damage * multiply
	else:
		SingletonBools.is_crit = false
		crit_damage = real_damage
	SingletonBools.real_damage = crit_damage

func reset_base() -> void:
	SingletonBools.real_damage = real_damage
