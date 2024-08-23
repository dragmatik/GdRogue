extends Node2D

@onready var chase_node: Node2D = $"../States/Chase_state"

# Ground Impact
func Get_ground_particles() -> void:
	var impact_scene: PackedScene = preload("res://Scenes/Effects/Particles/Ground_Particles.tscn")
	var impact: Node2D = impact_scene.instantiate()
	get_parent().add_child(impact)
	if chase_node.direction > 0:
		impact.global_position.x = $"../Attack/Area/Collider".global_position.x + 19
	elif chase_node.direction < 0:
		impact.global_position.x = $"../Attack/Area/Collider".global_position.x - 19
	else:
		pass # Get last direction
	impact.global_position.y = $"../Attack/Area/Collider".global_position.y + 12

# Ground Impact no attack collider
func Get_ground_particles_2() -> void:
	var impact_scene: PackedScene = preload("res://Scenes/Effects/Particles/Ground_Particles.tscn")
	var impact: Node2D = impact_scene.instantiate()
	get_parent().add_child(impact)
	if chase_node.direction > 0:
		impact.global_position.x = $"../Rock".global_position.x - 5
	elif chase_node.direction < 0:
		impact.global_position.x = $"../Rock".global_position.x + 5
	else:
		pass # Get last direction
	impact.global_position.y = $"../Rock".global_position.y
