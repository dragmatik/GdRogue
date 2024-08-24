extends Resource
class_name Ability

# Variables
@export var name: String
@export var cooldown: float
@export var duration: float
var is_active: bool = false
var is_on_cooldown: bool = false
var last_used_time: float

# Activate the ability if it's not on cooldown
func activate(current_time: float) -> bool:
	if not is_on_cooldown:
		is_active = true
		is_on_cooldown = true
		last_used_time = current_time
		return true
	return false

# Update the ability status based on the current time
func update(current_time: float) -> void:
	# Update cooldown status
	if is_on_cooldown and current_time - last_used_time >= cooldown:
		is_on_cooldown = false
	# Update active status
	if is_active and current_time - last_used_time >= duration:
		is_active = false

# Get remaining cooldown time
func get_remaining_cooldown(current_time: float) -> float:
	if is_on_cooldown:
		return max(0, cooldown - (current_time - last_used_time))
	return 0

# Get remaining duration time
func get_remaining_duration(current_time: float) -> float:
	if is_active:
		return max(0, duration - (current_time - last_used_time))
	return 0

# Check if the ability is activated
func is_activated() -> bool:
	return is_active

# Check if the ability is on cooldown
func is_cooldown() -> bool:
	return is_on_cooldown
