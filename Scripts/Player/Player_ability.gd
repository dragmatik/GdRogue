extends Node

#### Ability Class #####

class Ability:

	# Variables
	var cooldown: float = 0.0
	var duration: float = 0.0
	var is_active: bool = false
	var is_on_cooldown: bool = false
	var last_used_time: float = 0.0

	# Initialize using new()
	func _init(x: float, y: float) -> void:
		self.cooldown = x
		self.duration = y

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

#### Ability Script ####

# Variables
var current_time: float = 0.0
var skill_name: String

# Dictionary to hold abilities with cooldown and duration
var abilities: Dictionary = {
	"running": Ability.new(5.0, 3.0),
	"buff": Ability.new(10.0, 6.0) 
}

func _process(delta: float) -> void:
	current_time += delta
	for ability in abilities.values():
		ability.update(current_time)
	
	if SingletonBools.Is_ability_1:
		handle_running_ability()
	elif SingletonBools.Is_ability_2:
		handle_buff_ability()

# Callable
func skills() -> void:
	if SingletonBools.Is_ability_1:
		skill_name = "running"
	elif SingletonBools.Is_ability_2:
		skill_name = "buff"
	else:
		skill_name = "none"
	var ability: Ability = abilities.get(skill_name)
	if ability and ability.activate(current_time):
		pass # skill activation

# Get remaining cooldown of the current skill
func get_remaining_cooldown() -> float:
	var ability: Ability = abilities.get(skill_name)
	if ability:
		return ability.get_remaining_cooldown(current_time)
	return 0

# Get remaining duration of the current skill
func get_remaining_duration() -> float:
	var ability: Ability = abilities.get(skill_name)
	if ability:
		return ability.get_remaining_duration(current_time)
	return 0

# Get the cooldown value of the current skill
func get_cooldown_value() -> float:
	var ability: Ability = abilities.get(skill_name)
	if ability:
		return ability.cooldown
	return 0

# Get the duration value of the current skill
func get_duration_value() -> float:
	var ability: Ability = abilities.get(skill_name)
	if ability:
		return ability.duration
	return 0

#### Abilities ####

func handle_running_ability() -> void:
	var running_ability: Ability = abilities["running"]
	if running_ability.is_activated():
		$"../Outline".play("speed")
	else:
		$"../Outline".play("RESET")
		$"../Outline".stop()

func handle_buff_ability() -> void:
	var buff_ability: Ability = abilities["buff"]
	if buff_ability.is_activated():
		$"../Outline".play("buff")
	else:
		$"../Outline".play("RESET")
		$"../Outline".stop()
