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

# Ability & Skill bools
var Is_Thunder: bool = false
var Is_Bolt: bool = false
var Is_Bleed: bool = false

var Is_Fire_ball: bool = false # just for the icons
var Is_Force_field: bool = false # just for the icons

# Ability & Skill damage
var Thunder_damage: int = 20
var Bolt_damage: int = 250
var Bleed_damage: int = 10

var Fire_ball_damage: int = 45
