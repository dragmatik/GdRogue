extends Node

# Inventory
var Coins: int = 0

# Crit rate
var is_crit: bool = false
var crit_rate: float = 0.1

# Damage
var Base_damage: float = 0
var real_damage: float = 0

# Upgrades
var sharpner_counter: int = 0
func calculate_damage() -> float:
	var multiplier: float = 1.0 + (sharpner_counter * 0.15)
	return float(Base_damage * multiplier)

# Skills: Bools and Damage variables
var Is_Thunder: bool = false
var Thunder_damage: int = 20

var Is_Bolt: bool = false
var Bolt_damage: int = 250

var Is_Bleed: bool = false
var Bleed_damage: int = 10

# Abilities: Bools and Damage variables
var Ab_Is_Fire_ball: bool = false
var Fire_ball_damage: int = 45

var Ab_Is_Force_field: bool = false

# If an ability is True, the rest are False
func set_active_ability(active_ability: String) -> void:
	# Deactivate all abilities
	Ab_Is_Fire_ball = false
	Ab_Is_Force_field = false
	# Activate the selected ability
	match active_ability:
		"Ab_Is_Fire_ball":
			Ab_Is_Fire_ball = true
		"Ab_Is_Force_field":
			Ab_Is_Force_field = true
