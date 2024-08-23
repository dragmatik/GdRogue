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

func _on_d_toggled(toggled_on: bool) -> void:
	if toggled_on:
		SingletonBools.Is_ability_1 = true
		$"../../../cooldown_bar/Icons/Swift".visible = true
	else:
		SingletonBools.Is_ability_1 = false
		$"../../../cooldown_bar/Icons/Swift".visible = false

func _on_e_toggled(toggled_on: bool) -> void:
	if toggled_on:
		SingletonBools.Is_ability_2 = true
		$"../../../cooldown_bar/Icons/Buff".visible = true
	else:
		SingletonBools.Is_ability_2 = false
		$"../../../cooldown_bar/Icons/Buff".visible = false
