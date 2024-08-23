extends Node

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite

func _process(_delta: float) -> void:
	animated_sprite.play("default")
	await animated_sprite.animation_finished
	queue_free()
