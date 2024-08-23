extends Node

# Imports
@onready var flame_particles: GPUParticles2D = $Flame
@onready var smoke_particles: GPUParticles2D = $Flame/Smoke
@onready var collider: CollisionShape2D = $Area/Collider
@onready var timer: Timer = $Timer
@onready var timer_2: Timer = $Timer_2

func _ready() -> void:
	start_fire()

func start_fire() -> void:
	timer.start(3)

func _on_timer_timeout() -> void:
	flame_particles.emitting = false
	smoke_particles.emitting = false
	collider.disabled = true
	timer_2.start(1)

func _on_timer_2_timeout() -> void:
	queue_free()
