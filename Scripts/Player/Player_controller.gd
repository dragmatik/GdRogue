extends CharacterBody2D

# Movement Variables
var SPEED: float = 150
const SLIDE_SPEED: int = 200
const DASH_SPEED: int = 400
const JUMP_VELOCITY: int = -300
const DOUBLE_JUMP_VELOCITY: int = -250

# Base Variables
var direction: float = 0.0
var prev_direction: float = 0.0
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

# State Bools
var is_sliding: bool = false
var is_dashing: bool = false
var is_hanging: bool = false

# Sliding
const SLIDE_DURATION: float = 0.6
const SLIDE_COOLDOWN: float = 0.06
var slide_timer: float = 0.0
var cooldown_timer: float = 0.0

# Jumping
var jumps: int = 0
var max_jumps: int = 2
var JUMP_BUFFER: bool = false # so the player doesn't jump on the start
var was_in_air: bool = false # Track whether the player was previously in the air

# Dashing
const DASH_DURATION: float = 0.2
var dash_timer: float = 0.0
var dashes: int = 0
var max_dashes: int = 1

# Dust effect
var walk_interval: float = 0.2
var short_interval: float = 0.01
var dust_timer: float = 0.0

# Imports
@onready var sprite_node: Node2D = $Sprite
@onready var animation_node: AnimationPlayer = $Animation
@onready var weapon_sprite: Sprite2D = $Equipment/Weapon
@onready var health_node: Node2D = $HP
@onready var attack_node: Node2D = $Attacking
@onready var block_node: Node2D = $Blocking
@onready var attack_area: Area2D = $Attacking/Slash
@onready var shield_area: Area2D = $Blocking/Shield
@onready var attack_collider: CollisionShape2D = $Attacking/Slash/Collider
@onready var emitter_1: Node2D = $Emitters/Emitter_1
@onready var emitter_2: Node2D = $Emitters/Emitter_2
@onready var Ability_node: Node2D = $Ability
@onready var hitbox_collider: CollisionShape2D = $Hitbox/Collider
@onready var hanger: Area2D = $Hanger

# Player state
enum player_state {MOVE, ATTACK, DEAD, PARRY, DASH, HIT, HANG}
var current_state: player_state = player_state.MOVE

func _physics_process(delta: float) -> void:
	# State machine to handle different player states
	match current_state:
		player_state.MOVE:
			movement(delta)
		player_state.ATTACK:
			attack_node.attack(delta)
		player_state.DEAD:
			health_node.death(delta)
		player_state.PARRY:
			block_node.parry(delta)
		player_state.DASH:
			air_dash(delta)
		player_state.HIT:
			health_node.hit()
		player_state.HANG:
			hang()

func movement(delta: float) -> void:
	# Add gravity when not on the floor
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		# Reset jumps, dashes
		attack_collider.disabled = true # canceled attacks won't leave the collider on
		jumps = 0
		dashes = 0

		# Check for buffered jump
		if JUMP_BUFFER:
			jump()
			JUMP_BUFFER = false

		# Check if the player just landed
		if was_in_air:
			if not sprite_node.flip_h:
				dust_maker(delta, 1, short_interval, emitter_1.global_position) 
			else:
				dust_maker(delta, -1, short_interval, emitter_1.global_position) 
			was_in_air = false

	# Handle jump and fall animations
	if not is_on_floor():
		if velocity.y < 0:
			animation_node.play("jump")
		if velocity.y > 0:
			animation_node.play("fall")
		was_in_air = true

	# Handle jump input
	if Input.is_action_just_pressed("ui_jump"):
		if jumps < max_jumps:
			jump()
			dust_maker(delta, 1, short_interval, emitter_1.global_position)
		else:
			# Set bufferer for next use
			JUMP_BUFFER = true

	# Handle dash input
	if Input.is_action_just_pressed("ui_slide") and not is_on_floor() and not is_dashing and dashes < max_dashes:
		current_state = player_state.DASH
		is_dashing = true
		dashes += 1
		dash_timer = DASH_DURATION

	# Handle slide input
	if Input.is_action_just_pressed("ui_slide") and is_on_floor() and not is_sliding and cooldown_timer <= 0:
		is_sliding = true
		slide_timer = SLIDE_DURATION
		# on stop, direction = 0 so can't get value. I had to use another method to flip the dust 
		if not sprite_node.flip_h:
			dust_maker(delta,  1, short_interval, emitter_1.global_position) 
		else:
			dust_maker(delta, -1, short_interval, emitter_1.global_position) 

	# Handle Power ups
	if Input.is_action_just_pressed("ui_special"):
		Ability_node.skills()

	if is_sliding:
		# Slide movement
		if sprite_node.flip_h:
			velocity.x = -SLIDE_SPEED
		else:
			velocity.x = SLIDE_SPEED
		# Slide mechanics
		animation_node.play("slide")
		ghost_maker(delta)
		slide_timer -= delta
		if slide_timer <= 0:
			hitbox_collider.disabled = false # Enable collider to take damage
			# collision_mask |= (1 << 2)
			is_sliding = false
			cooldown_timer = SLIDE_COOLDOWN
			if not sprite_node.flip_h:
				dust_maker(delta, -1, short_interval, emitter_2.global_position)
			else:
				dust_maker(delta, 1, short_interval, emitter_2.global_position)
		elif slide_timer > 0:
			hitbox_collider.disabled = true # Disable collider to avoid damage
			# collision_mask &= ~(1 << 2)

	# Update slide cooldown timer
	if cooldown_timer > 0:
		cooldown_timer -= delta

	# Get input direction and handle movement
	direction = Input.get_axis("ui_left", "ui_right")
	
	if direction > 0 and not is_sliding:
		velocity.x = direction * SPEED
		if is_on_floor():
			if direction < 0.5:
				animation_node.play("walk")
			else:
				animation_node.play("run")
			dust_maker(delta, direction, walk_interval, emitter_1.global_position) # release particles only when on the floor
		hanger.position.x = 13.5
		emitter_2.position.x = 10
		sprite_node.flip_h = false  # Don't flip the sprite when moving right
		weapon_sprite.flip_h = false
		attack_area.position.x = 37
		shield_area.position.x = 15
	
	elif direction < 0 and not is_sliding:
		velocity.x = direction * SPEED
		if is_on_floor():
			if direction > -0.5:
				animation_node.play("walk")
			else:
				animation_node.play("run")
			dust_maker(delta, direction, walk_interval, emitter_1.global_position) # release particles only when on the floor
		hanger.position.x = -13.5
		emitter_2.position.x = -10
		sprite_node.flip_h = true  # Flip the sprite when moving left
		weapon_sprite.flip_h = true
		attack_area.position.x = -37
		shield_area.position.x = -15
	
	elif direction == 0 and not is_sliding:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			if prev_direction != 0:
				dust_maker(delta, -prev_direction, short_interval, emitter_2.global_position) # create opposite dust particles for stopping
			animation_node.play("idle")
	prev_direction = direction
	
	weapon_sprite.visible = false
	is_hanging = false
	move_and_slide()

func air_dash(delta: float) -> void:
	if is_dashing:
		animation_node.play("dash")
		ghost_maker(delta)
		dash_timer -= delta
		if dash_timer <= 0:
			hitbox_collider.disabled = false
			is_dashing = false
			# collision_mask |= (1 << 2)
			reset_state()
		else:
			hitbox_collider.disabled = true
			# collision_mask &= ~(1 << 2)
		velocity.x = DASH_SPEED if !sprite_node.flip_h else -DASH_SPEED
		velocity.y = 0
	move_and_slide()

func jump() -> void:
	if jumps == 0:
		velocity.y = JUMP_VELOCITY
	elif jumps == 1:
		velocity.y = DOUBLE_JUMP_VELOCITY
	jumps += 1

func hang() -> void:
	if not is_hanging:
		animation_node.play("hang")
		await animation_node.animation_finished
		is_hanging = true # play the animation once then proceed to the rest
	else:
		# Reset everything similar to being on the floor
		attack_collider.disabled = true
		jumps = 0
		dashes = 0
		is_dashing = false
		is_sliding = false
		attack_node.is_attacking = false
		velocity.y = 0 # so the gravity doesn't increase by time
	if Input.is_action_just_pressed("ui_jump") and not Input.is_action_pressed("ui_down") and is_hanging:
		# is_hanging = false exists in loop inside the move state
		current_state = player_state.MOVE
		jump()
	elif Input.is_action_just_pressed("ui_jump") and Input.is_action_pressed("ui_down") and is_hanging:
		current_state = player_state.MOVE

func _on_hanger_area_entered(_area: Area2D) -> void:
	# trigger the hang state when colliding with a cliff
	current_state = player_state.HANG
 
func reset_state() -> void:
	# Reset player state to move
	current_state = player_state.MOVE
	attack_node.is_attacking = false

# Ghost effect
var ghost_scene: PackedScene = preload("res://Scenes/Effects/Ghost.tscn")
var ghost_interval: float = 0.08
var ghost_timer: float = 0.0

# Create a multi-frame effect behind the character
func ghost_maker(delta: float) -> void:
	ghost_timer += delta
	if ghost_timer >= ghost_interval:
		var ghost: Node2D = ghost_scene.instantiate()
		get_parent().add_child(ghost)
		ghost.global_position = sprite_node.global_position
		ghost.scale = sprite_node.scale
		ghost.texture = sprite_node.texture
		ghost.vframes = sprite_node.vframes
		ghost.hframes = sprite_node.hframes
		ghost.frame = sprite_node.frame
		ghost.flip_h = sprite_node.flip_h
		ghost.modulate = Color(1, 0, 1, 0.5)
		ghost_timer = 0.0

# Create dust particles
func dust_maker(delta: float, x: float, interval: float, pos: Vector2) -> void:
	dust_timer += delta
	if dust_timer >= interval:
		var dust_scene: PackedScene = preload("res://Scenes/Effects/Particles/Dust.tscn")
		var dust: Node2D = dust_scene.instantiate()
		get_parent().add_child(dust)
		dust.global_position = pos
		dust.Release_dust(x)
		dust_timer = 0.0
