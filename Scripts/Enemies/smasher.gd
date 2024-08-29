extends Node

# Imports
@onready var main: CharacterBody2D = $".."
@onready var sprite: AnimatedSprite2D = $"../Sprite"
@onready var animation: AnimationPlayer = $"../Animation"
@onready var attack_collider: CollisionShape2D = $"../Attack/Area/Collider"
@onready var detection_collider: CollisionShape2D = $"../Detection/Collider"
@onready var ground: RayCast2D = $"../Movement/Ground"
@onready var wall: RayCast2D = $"../Movement/Wall"
@onready var cooldown: Timer = $"../Timers/Cooldown"
@onready var turn_around: Timer = $"../Timers/Turn_around"

# Variables & Bools
var can_attack: bool = true
var direction: float = 0.0
var path: int = 1
var is_idle: bool = false

# Flip character right
func flip_right() -> void:
	sprite.flip_h = false  # Don't flip if moving right
	wall.rotation = deg_to_rad(-90)
	wall.position.x = 30
	ground.position.x = 30
	detection_collider.position.x = 25
	attack_collider.position.x = 29

# Flip character left
func flip_left() -> void:
	sprite.flip_h = true  # Flip if moving left
	wall.rotation = deg_to_rad(90)
	wall.position.x = -30
	ground.position.x = -30
	detection_collider.position.x = -25
	attack_collider.position.x = -29

# Attack function
func attack(delta: float) -> void:
	# Attack state behavior
	if not main.is_on_floor():
		main.gravity_func(delta)
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
	# Movement state behavior
	if not main.is_on_floor():
		main.gravity_func(delta)
	else:
		main.ghost_maker(delta)
		direction = main.player.global_position.x - sprite.global_position.x
		main.velocity.x = direction * main.Speed
		if direction > 0:
			flip_right()
		elif direction < 0:
			flip_left()
		else:
			pass
		animation.play("run")
	main.move_and_slide()

# Idle function
func idle(delta: float) -> void:
	if is_idle:
		animation.play("idle")
		return
	if not main.is_on_floor():
		main.gravity_func(delta)
	else:
		main.velocity.y = 0
		main.velocity.x = path * main.Speed * main.Speed_idle
		if wall.is_colliding() or not ground.is_colliding():
			is_idle = true
			turn_around.start(2)
		if path > 0:
			flip_right()
		elif path < 0:
			flip_left()
		animation.play("run")
	main.move_and_slide()
	
func _on_turn_around_timeout() -> void:
	if wall.is_colliding() or not ground.is_colliding():
		path *= -1
	is_idle = false

# Ground Impact
func Get_ground_particles() -> void:
	var impact_scene: PackedScene = preload("res://Scenes/VFX/Particles/Ground_Particles.tscn")
	var impact: Node2D = impact_scene.instantiate()
	get_parent().add_child(impact)
	if direction > 0:
		impact.global_position.x = attack_collider.global_position.x + 19
	elif direction < 0:
		impact.global_position.x = attack_collider.global_position.x - 19
	else:
		pass # Get last direction
	impact.global_position.y = attack_collider.global_position.y + 12
