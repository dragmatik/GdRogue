extends Node

# Imports
@onready var Abilities_node: Node2D = $"../Power_ups"

# Variables
@export var current_ability: Ability
var current_time: float = 0.0

func _process(delta: float) -> void:
	# Start in-game timer
	current_time += delta
	# Update ability state
	if current_ability:
		current_ability.update(current_time)
		# Passive abilities

# Callable function
func skills() -> void:
	if current_ability and not current_ability.is_on_cooldown:
		# Activate the ability
		if current_ability.activate(current_time):
			# Trigger the ability effect
			if current_ability.name == "fire_ball":
				Abilities_node.fire_ball_on()
			elif current_ability.name == "force_field":
				Abilities_node.force_field_on()

# Get remaining cooldown of the current skill
func get_remaining_cooldown() -> float:
	if current_ability:
		return current_ability.get_remaining_cooldown(current_time)
	return 0

# Get remaining duration of the current skill
func get_remaining_duration() -> float:
	if current_ability:
		return current_ability.get_remaining_duration(current_time)
	return 0

# Get the cooldown value of the current skill
func get_cooldown_value() -> float:
	if current_ability:
		return current_ability.cooldown
	return 0

# Get the duration value of the current skill
func get_duration_value() -> float:
	if current_ability:
		return current_ability.duration
	return 0
