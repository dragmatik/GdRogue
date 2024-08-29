extends Node

# Imports
@onready var particles: GPUParticles2D = $Particles
@onready var proj_collider: CollisionShape2D = $Area/Collision
@onready var proj_timer: Timer = $Timer
@onready var queue_timer: Timer = $Queue_free
@onready var direction: Vector2 = (player_position - self.global_position).normalized()
var player_position: Vector2

# Variables
var current_speed: float = 60
var expired: bool = false

func _ready() -> void:
	if $"..".player:
		player_position = $"..".player.global_position
	else:
		player_position = Vector2.ZERO
	proj_collider.disabled = false
	proj_timer.start(3.0)

func _process(delta: float) -> void:
	if not expired:                                                                                                                              
		# Update the player position (follow player)
		if $"..".player:
			player_position = $"..".player.global_position
		# Move towards the direction
		direction = (player_position - self.global_position).normalized()
		self.global_position += direction * current_speed * delta

func _on_area_area_entered(area: Area2D) -> void:
	# If projectile collides with something, expire
	if area.name != "Hitbox":
		pass
	else:
		trigger_expiration()

func _on_timer_timeout() -> void:
	trigger_expiration()

func trigger_expiration() -> void:
	proj_collider.call_deferred("set_disabled", true)
	expired = true
	particles.emitting = false
	queue_timer.start(1)

func _on_queue_free_timeout() -> void:
	queue_free()
