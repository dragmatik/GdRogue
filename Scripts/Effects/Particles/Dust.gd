extends GPUParticles2D

func _ready() -> void:
	emitting = true # One shot should be ON on editor

func Release_dust(x: float) -> void:
	if x > 0:
		process_material.gravity.x = -100
	else:
		process_material.gravity.x = 100

func _on_finished() -> void:
	queue_free()
