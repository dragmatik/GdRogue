extends Node2D

# Imports
@onready var attack_node: Node2D = $"../Primary_attack"

# Variables
var current_weapon: Equipment
var real_damage: float = 0 # store base damage before crit
var crit_damage: float = 0 # critical value of base damage

func _process(_delta: float) -> void:
	current_weapon = attack_node.current_equipment
	# Passive weapon skills

func attack_part1() -> void:
	# Instant weapon skills
	if current_weapon.name == "Basic Sword":
		print(1)

func attack_part2() -> void:
	# Instant weapon skills
	if current_weapon.name == "Basic Sword":
		print(2)

func attack_part3() -> void:
	# Instant weapon skills
	if current_weapon.name == "Basic Sword":
		print(3)

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
