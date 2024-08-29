extends Node

@onready var particles: GPUParticles2D = $Particles
@onready var timer: Timer = $Timer

func _ready() -> void:
	particles.emitting = true
	timer.start(0.4)

func _on_timer_timeout() -> void:
	queue_free()
