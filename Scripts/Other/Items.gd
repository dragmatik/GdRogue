extends VBoxContainer

func _on_a_toggled(toggled_on: bool) -> void:
	if toggled_on:
		SingletonBools.Is_Thunder = true
		$"../../../Abilities/Ability_Icons/T".visible = true
	else:
		SingletonBools.Is_Thunder = false
		$"../../../Abilities/Ability_Icons/T".visible = false

func _on_b_toggled(toggled_on: bool) -> void:
	if toggled_on:
		SingletonBools.Is_Bleed = true
		$"../../../Abilities/Ability_Icons/B".visible = true
	else:
		SingletonBools.Is_Bleed = false
		$"../../../Abilities/Ability_Icons/B".visible = false

func _on_c_toggled(toggled_on: bool) -> void:
	if toggled_on:
		SingletonBools.Is_Bolt = true
		$"../../../Abilities/Ability_Icons/T2".visible = true
	else:
		SingletonBools.Is_Bolt = false
		$"../../../Abilities/Ability_Icons/T2".visible = false

@onready var fire_ball: Ability = preload("res://Resources/Skills/fire_ball.tres")
@onready var force_field: Ability = preload("res://Resources/Skills/force_field.tres")

func _on_d_pressed() -> void:
	$"../../../cooldown_bar/Icons/Swift".visible = true
	$"../../../cooldown_bar/Icons/Buff".visible = false
	$"../../../../Ability".current_ability = fire_ball

func _on_e_pressed() -> void:
	$"../../../cooldown_bar/Icons/Buff".visible = true
	$"../../../cooldown_bar/Icons/Swift".visible = false
	$"../../../../Ability".current_ability = force_field
