extends Node

# Imports
@onready var direction: bool = $"../Enemy/Unique".projectile_direction
@onready var proj_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var proj_collider: CollisionShape2D = $Area/Collision
@onready var proj_timer: Timer = $Timer

# Variables
var acceleration: int = 500
var current_speed: float = 150
var destroyed: bool = false

func _ready() -> void:
	proj_collider.disabled = false
	proj_timer.start(3.0)

func _process(delta: float) -> void:
	# Handle direction
	if not destroyed:
		if not direction:
			proj_sprite.flip_h = true # if enemy looking left flip the projectile to the left
			self.position.x -= current_speed * delta # move to the left
		else:
			proj_sprite.flip_h = false # if enemy looking right flip the projectile to the right
			self.position.x += current_speed * delta # move to the right
		
		# Increase speed gradually
		current_speed += acceleration * delta
		
		# Handle animation
		proj_sprite.play("default")
	else:
		projectile_destroyed()

func _on_timer_timeout() -> void:
	destroyed = true

func _on_area_area_entered(area: Area2D) -> void:
	if area.name != "Hitbox":
		pass
	else:
		destroyed = true

func projectile_destroyed() -> void:
	proj_collider.disabled = true
	proj_sprite.play("expired")
	await proj_sprite.animation_finished
	queue_free()
