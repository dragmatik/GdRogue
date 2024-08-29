extends CharacterBody2D

# Imports 
@onready var unique: Node = $Unique
@onready var hp: Node2D = $HP
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var animation: AnimationPlayer = $Animation
@onready var hitbox_collider: CollisionShape2D = $Hitbox/Collider
@onready var camera: Camera2D = $"../../player/Camera"

# Unique variables
@export var stats: Enemy
@onready var Speed: float = stats.speed
@onready var Speed_idle: float = stats.speed_idle
@onready var attack_cooldown: float = stats.attack_cooldown
var Health: float = 1000 # to fix!

# Common variables & bools
var body_in_attacker: bool = false  # whether the player is inside the attack collider
var vision: bool = false # whether there is a player
var got_hit: bool = false
var enemy_is_dead: bool = false
var player: CharacterBody2D = null  # get the player body
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

# States
enum enemy_state {IDLE, CHASE, ATTACK, HIT, DEAD}
var current_state: enemy_state = enemy_state.IDLE

func _physics_process(delta: float) -> void:
	match current_state:
		enemy_state.IDLE:
			unique.idle(delta)
		enemy_state.CHASE:
			unique.chase(delta)
		enemy_state.ATTACK:
			unique.attack(delta)
		enemy_state.HIT:
			hit()
		enemy_state.DEAD:
			death(delta)

# State changes
func _process(_delta: float) -> void:
	if hp.enemy_health <= 0:
		enemy_is_dead = true
		current_state = enemy_state.DEAD  # Transition to death state

func _on_vision_det_body_entered(body: CharacterBody2D) -> void:
	player = body
	vision = true
	if current_state == enemy_state.IDLE:
		current_state = enemy_state.CHASE  # Transition to move state if idle

func _on_vision_det_body_exited(_body: CharacterBody2D) -> void:
	player = null
	vision = false
	if current_state == enemy_state.CHASE:
		current_state = enemy_state.IDLE  # Transition back to idle if player is out of vision

func _on_attacker_det_body_entered(_body: CharacterBody2D) -> void:
	body_in_attacker = true
	if not enemy_is_dead:  # can't attack while dead
		current_state = enemy_state.ATTACK
	else:
		current_state = enemy_state.DEAD

func _on_attacker_det_body_exited(_body: CharacterBody2D) -> void:
	body_in_attacker = false
	got_hit = false
	await $Animation.animation_finished  # Wait for animation, test using print(direction)
	if body_in_attacker:  # elif vision used to override the enter function so this was added
		current_state = enemy_state.ATTACK  # Stay in slash state if still in attacker collider
	elif vision:
		current_state = enemy_state.CHASE  # Transition back to move if player is in vision
	else:
		current_state = enemy_state.IDLE  # Otherwise, go back to idle state

func _on_hitbox_area_entered(area: Area2D) -> void:
	hp.handle_damage(area)
	if not enemy_is_dead:
		# if not got_hit to not spam
			got_hit = true
			current_state = enemy_state.HIT

# Gravity function
func gravity_func(delta: float) -> void:
	velocity.y += gravity * delta
	move_and_slide()

# Hit function
func hit() -> void:
	animation.play("hit")
	await animation.animation_finished
	if enemy_is_dead:
		current_state = enemy_state.DEAD
	elif body_in_attacker:
		current_state = enemy_state.ATTACK
	elif vision:
		current_state = enemy_state.CHASE
	else:
		current_state = enemy_state.IDLE

# Death function
func death(delta: float) -> void:
	if not is_on_floor():
		gravity_func(delta)
	# Death state behavior
	hitbox_collider.disabled = true
	animation.play("death")
	await animation.animation_finished  # Wait for death animation to finish
	queue_free()  # Free the enemy node from the scene

# Shake function
func shake_ground() -> void:
	camera.shake(4.0, 8.0)

# Ghost function
var ghost_scene: PackedScene = preload("res://Scenes/VFX/Textures/Ghost.tscn")
var ghost_interval: float = 0.1
var ghost_timer: float = 0.0
func ghost_maker(delta: float) -> void:
	ghost_timer += delta
	if ghost_timer >= ghost_interval:
		var ghost: Node2D = ghost_scene.instantiate()
		get_parent().add_child(ghost)
		ghost.global_position = sprite.global_position
		ghost.scale = sprite.scale
		ghost.texture = sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame)
		ghost.flip_h = sprite.flip_h
		ghost.modulate = Color(1, 1, 1, 0.5)
		ghost_timer = 0.0

# Coin function
func Spawn_coins() -> void:
	for i in range(5):
		var coin_scene: PackedScene = preload("res://Scenes/Items/Coin.tscn")
		var coin: Node2D = coin_scene.instantiate()
		get_tree().current_scene.add_child(coin)
		coin.global_position = sprite.global_position
