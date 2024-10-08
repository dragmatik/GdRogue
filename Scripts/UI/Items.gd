extends VBoxContainer

func _on_a_toggled(toggled_on: bool) -> void:
	if toggled_on:
		SingletonBools.Is_Thunder = true
	else:
		SingletonBools.Is_Thunder = false

func _on_b_toggled(toggled_on: bool) -> void:
	if toggled_on:
		SingletonBools.Is_Bleed = true
	else:
		SingletonBools.Is_Bleed = false

func _on_c_toggled(toggled_on: bool) -> void:
	if toggled_on:
		SingletonBools.Is_Bolt = true
	else:
		SingletonBools.Is_Bolt = false

@onready var fire_ball: Ability = preload("res://Resources/Ability_class/fire_ball.tres")
@onready var force_field: Ability = preload("res://Resources/Ability_class/force_field.tres")
@onready var ability_node: Node2D = $"../../../../Get_abilities"

func _on_d_pressed() -> void:
	ability_node.current_ability = fire_ball
	SingletonBools.set_active_ability("Ab_Is_Fire_ball")

func _on_e_pressed() -> void:
	ability_node.current_ability = force_field
	SingletonBools.set_active_ability("Ab_Is_Force_field")
