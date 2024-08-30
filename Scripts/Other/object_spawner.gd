extends Node2D

# Define the preloaded scenes with static typing
var enemy1: PackedScene = preload("res://Scenes/Enemies/Smasher.tscn")
var enemy2: PackedScene = preload("res://Scenes/Enemies/Ranger.tscn")
var enemy3: PackedScene = preload("res://Scenes/Enemies/Winged.tscn")
var enemy4: PackedScene = preload("res://Scenes/Enemies/Mage.tscn")
var enemy5: PackedScene = preload("res://Scenes/Enemies/Earthshaker.tscn")
var enemy6: PackedScene = preload("res://Scenes/Enemies/Necro.tscn")
var enemy7: PackedScene = preload("res://Scenes/Enemies/Lancer.tscn")
# var enemy7: PackedScene = preload("res://Scenes/Bosses/Boss_Prime.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_spawn_1"):
		var instance1: Node2D = enemy1.instantiate() as Node2D
		get_tree().current_scene.add_child(instance1)
		instance1.global_position = $".".global_position
	if event.is_action_pressed("ui_spawn_2"):
		var instance2: Node2D = enemy2.instantiate() as Node2D
		get_tree().current_scene.add_child(instance2)
		instance2.global_position = $".".global_position
	if event.is_action_pressed("ui_spawn_3"):
		var instance3: Node2D = enemy3.instantiate() as Node2D
		get_tree().current_scene.add_child(instance3)
		instance3.global_position = $".".global_position
	if event.is_action_pressed("ui_spawn_4"):
		var instance4: Node2D = enemy4.instantiate() as Node2D
		get_tree().current_scene.add_child(instance4)
		instance4.global_position = $".".global_position
	if event.is_action_pressed("ui_spawn_5"):
		var instance5: Node2D = enemy5.instantiate() as Node2D
		get_tree().current_scene.add_child(instance5)
		instance5.global_position = $".".global_position
	if event.is_action_pressed("ui_spawn_6"):
		var instance6: Node2D = enemy6.instantiate() as Node2D
		get_tree().current_scene.add_child(instance6)
		instance6.global_position = $".".global_position
	if event.is_action_pressed("ui_spawn_7"):
		var instance7: Node2D = enemy7.instantiate() as Node2D
		get_tree().current_scene.add_child(instance7)
		instance7.global_position = $".".global_position
