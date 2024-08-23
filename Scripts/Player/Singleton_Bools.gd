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

# Abilities
var Is_Thunder: bool = false
var Thunder_damage: int = 20

var Is_Bolt: bool = false
var Bolt_damage: int = 250

var Is_Bleed: bool = false
var Bleed_damage: int = 10

# Skills
var Is_ability_1: bool = false
var Is_ability_2: bool = false
