extends RigidBody2D

# Direction of the rock
var rock_direction: float = 0.0
var height: float = 0.0
var side: float = 300
var expired: bool = false

# Imports
@onready var chase_node: Node2D = $"../Enemy/States/Chase_state"
@onready var proj_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var proj_collider: CollisionShape2D = $Area/Collider

func _ready() -> void:
	proj_collider.disabled = false
	height = randf_range(-450, -350)
	rock_direction = chase_node.direction
	if rock_direction:
		if rock_direction < 0:
			apply_impulse(Vector2(-side, height), Vector2(1, -1))
		else:
			apply_impulse(Vector2(side, height), Vector2(1, -1))

func _process(_delta: float) -> void:
	if not expired:
		proj_sprite.play("default")
	else:
		expire()

func expire() -> void:
	proj_collider.disabled = true
	proj_sprite.play("expired")
	await proj_sprite.animation_finished
	queue_free()

func _on_area_body_entered(_body) -> void: # dynamic typing (body could be anything)
	expired = true
