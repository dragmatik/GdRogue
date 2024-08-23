extends Node

# Imports
@onready var proj_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var proj_collider: CollisionShape2D = $Area/Collision
@onready var proj_timer: Timer = $Timer
@onready var player_position = $"../Enemy".player_pos
@onready var direction: Vector2 = (player_position - self.global_position).normalized()

# Variables
var current_speed: float = 60
var expired: bool = false

func _ready() -> void:
	proj_collider.disabled = false
	proj_timer.start(3.0)

func _process(delta: float) -> void:
	if not expired:                                                                                                                              
		# Update the player position (follow player)
		player_position = $"../Enemy".player_pos
		# Move towards the direction
		direction = (player_position - self.global_position).normalized()
		self.global_position += direction * current_speed * delta
		proj_sprite.play("default")

func _on_area_area_entered(area: Area2D) -> void:
	# If projectile collides with something, expire
	if area.name != "Hitbox":
		pass
	else:
		trigger_expiration()

func _on_timer_timeout() -> void:
	trigger_expiration()

func trigger_expiration() -> void:
	proj_collider.disabled = true
	expired = true
	proj_sprite.play("expired")
	await proj_sprite.animation_finished
	queue_free()
