extends Node

# Imports
@onready var collider: CollisionShape2D = $damage/col
@onready var animation_node: AnimationPlayer = $anim
@onready var camera: Camera2D = $"../../../player/Camera"

func _ready() -> void:
	if collider:
		collider.disabled = true

func _process(_delta: float) -> void:
	animation_node.play("effect")
	await animation_node.animation_finished
	queue_free()

func shake_ground() -> void:
	camera.shake(8.0, 8.0)
