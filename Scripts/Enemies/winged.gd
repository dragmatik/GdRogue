extends Node

# Imports
@onready var main: CharacterBody2D = $".."
@onready var sprite: AnimatedSprite2D = $"../Sprite"
@onready var animation: AnimationPlayer = $"../Animation"
@onready var attack_marker: Marker2D = $"../Attack"
@onready var detection_collider: CollisionShape2D = $"../Detection/Collider"
@onready var ground: RayCast2D = $"../Movement/Ground"
@onready var wall: RayCast2D = $"../Movement/Wall"
@onready var cooldown: Timer = $"../Timers/Cooldown"
@onready var turn_around: Timer = $"../Timers/Turn_around"

# Variables & Bools
var can_attack: bool = true
var direction: Vector2
var path: int = 1
var is_idle: bool = false

# Flip character right
func flip_right() -> void:
	sprite.flip_h = false  # Don't flip if moving right
	wall.rotation = deg_to_rad(-90)
	wall.position.x = 30
	detection_collider.position.x = 55
	attack_marker.position.x = 7

# Flip character left
func flip_left() -> void:
	sprite.flip_h = true  # Flip if moving left
	wall.rotation = deg_to_rad(90)
	wall.position.x = -30
	detection_collider.position.x = -55
	attack_marker.position.x = -7

# Attack function
func attack(_delta: float) -> void:
	# Attack state behavior
	if can_attack:
		animation.play("attack")
		await animation.animation_finished
		can_attack = false
		cooldown.start(main.attack_cooldown)
	else:
		animation.play("idle")
	
func _on_cooldown_timeout() -> void:
	can_attack = true

# Chase function
func chase(delta: float) -> void:
	if main.player:
		main.ghost_maker(delta)
		direction = (main.player.global_position - main.global_position).normalized()
		main.velocity = direction * main.Speed
		# Determine facing direction and adjust animations
		if direction.x > 0:
			flip_right()
		elif direction.x < 0:
			flip_left()
		animation.play("run")
	main.move_and_slide()

# Idle function
func idle(delta: float) -> void:
	if is_idle:
		animation.play("idle")
		return
	if ground.is_colliding():
		animation.play("idle")
		main.velocity.y += -200 * delta
		main.velocity.x = 0
		main.move_and_slide()
	else:
		main.velocity.y = 0
		main.velocity.x = path * main.Speed_idle
		animation.play("run")
	if wall.is_colliding():
		is_idle = true
		turn_around.start(2)
	if path > 0:
		flip_right()
	elif path < 0:
		flip_left()
	sprite.position.y += sin(Time.get_ticks_msec() / 1000.0 * 2.0 * PI) * 0.5
	main.move_and_slide()
	
func _on_turn_around_timeout() -> void:
	if wall.is_colliding():
		path *= -1
	is_idle = false

# Ranged Projectile
func shoot() -> void:
	var projectile: PackedScene = preload("res://Scenes/Enemies/Attacks/Projectile_xy.tscn")
	var instance: Node2D = projectile.instantiate()
	get_parent().add_child(instance)
	instance.global_position = attack_marker.global_position
