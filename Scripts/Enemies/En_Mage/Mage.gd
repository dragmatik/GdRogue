extends CharacterBody2D

# Constants
const HEALTH = 1000
const SPEED = 1
const IDLE_SPEED = 60
const ATTACK_COOLDOWN = 2

# Collider Positions
var wall_raycast_position = 30
var ground_raycast_position = 30

# Collider Variables
var body_in_attacker = false  # whether the body is inside the attack collider
var player = null  # detect the player body to follow it
var vision = false  # whether the player is in the line of vision
var got_hit = false 
var enemy_is_dead = false

# States
var current_state = enemy_state.IDLE
enum enemy_state {IDLE, CHASE, ATTACK, HIT, DEAD, STUN}

func _physics_process(delta):
	# State machine to handle different enemy states
	match current_state:
		enemy_state.IDLE:
			$States/Idle_state.idle(delta)
		enemy_state.CHASE:
			$States/Chase_state.chase(delta)
		enemy_state.ATTACK:
			$States/Attack_state.attack(delta)
		enemy_state.HIT:
			$States/Hit_state.hit()
		enemy_state.DEAD:
			$States/Death_state.death(delta)
		enemy_state.STUN:
			$States/Stun_state.stun_enemy()

# Get bolt scene
var bolt = preload("res://Scenes/Enemies/Attacks/Lightning.tscn")
var warning = preload("res://Scenes/Enemies/Attacks/Lightning_2.tscn")
var player_target_x
var player_target_y

func create_bolt():
	if player_target_x and player_target_y:
		# Original bolt
		var bolt_instance = bolt.instantiate()
		get_parent().add_child(bolt_instance)
		bolt_instance.global_position.x = player_target_x
		bolt_instance.global_position.y = player_target_y

		# Bolt to the right
		var bolt_instance_right = bolt.instantiate()
		get_parent().add_child(bolt_instance_right)
		bolt_instance_right.global_position.x = player_target_x + 80
		bolt_instance_right.global_position.y = player_target_y

		# Bolt to the left
		var bolt_instance_left = bolt.instantiate()
		get_parent().add_child(bolt_instance_left)
		bolt_instance_left.global_position.x = player_target_x - 80
		bolt_instance_left.global_position.y = player_target_y
	
	# So that bolts don't spawn without warning after memorising the previous values
	player_target_x = null
	player_target_y = null

func create_warning():
	if player:
		if player.is_on_floor():
			# Original warning
			var warning_instance = warning.instantiate()
			get_parent().add_child(warning_instance)
			warning_instance.global_position.x = player.global_position.x
			warning_instance.global_position.y = player.global_position.y + 28
			player_target_x = warning_instance.global_position.x
			player_target_y = warning_instance.global_position.y

			# Warning to the right
			var warning_instance_right = warning.instantiate()
			get_parent().add_child(warning_instance_right)
			warning_instance_right.global_position.x = player.global_position.x + 80
			warning_instance_right.global_position.y = player.global_position.y + 28

			# Warning to the left
			var warning_instance_left = warning.instantiate()
			get_parent().add_child(warning_instance_left)
			warning_instance_left.global_position.x = player.global_position.x - 80
			warning_instance_left.global_position.y = player.global_position.y + 28

# State changes
func _on_vision_det_body_entered(body):
	player = body
	vision = true
	if not $States/Stun_state.is_stunned:
		if current_state == enemy_state.IDLE:
			current_state = enemy_state.CHASE  # Transition to move state if idle

func _on_vision_det_body_exited(_body):
	player = null
	vision = false
	if not $States/Stun_state.is_stunned:
		if current_state == enemy_state.CHASE:
			current_state = enemy_state.IDLE  # Transition back to idle if player is out of vision

func _on_attacker_det_body_entered(_body):
	body_in_attacker = true
	if not $States/Stun_state.is_stunned:
		if not enemy_is_dead: # so the enemy doesnt attack when is dead and player enters det
			current_state = enemy_state.ATTACK # Transition to slash state when player enters attacker collider
		else:
			current_state = enemy_state.DEAD # i can use this as a post dead state 

func _on_attacker_det_body_exited(_body):
	body_in_attacker = false
	got_hit = false
	await $Animation.animation_finished  # Wait for animation, test using print(direction)
	if not $States/Stun_state.is_stunned:
		if body_in_attacker:  # elif vision used to override the enter function so this was added
			current_state = enemy_state.ATTACK  # Stay in slash state if still in attacker collider
		elif vision:
			current_state = enemy_state.CHASE  # Transition back to move if player is in vision
		else:
			current_state = enemy_state.IDLE  # Otherwise, go back to idle state

func _process(_delta: float) -> void:
	if $HP.enemy_health <= 0:
		enemy_is_dead = true
		current_state = enemy_state.DEAD  # Transition to death state

func _on_hitbox_area_entered(area):
	$HP.handle_damage(area)
	if not enemy_is_dead:
		if not got_hit and not $States/Stun_state.is_stunned:
			got_hit = true  # get hit only once so you don't spam the enemy
			current_state = enemy_state.HIT  # Transition to hit state

func Spawn_coins():
	for i in range(5):
		var coin_scene = preload("res://Scenes/Items/Coin.tscn")
		var coin = coin_scene.instantiate()
		get_tree().current_scene.add_child(coin)
		coin.global_position = $Sprite.global_position

# Ghost effect
var ghost_scene = preload("res://Scenes/VFX/Textures/Ghost.tscn")
var ghost_interval = 0.1
var ghost_timer = 0.0

func ghost_maker(delta):
	ghost_timer += delta
	if ghost_timer >= ghost_interval:
		var ghost = ghost_scene.instantiate()
		get_parent().add_child(ghost)
		ghost.global_position = $Sprite.global_position
		ghost.scale = $Sprite.scale
		ghost.texture = $Sprite.sprite_frames.get_frame_texture($Sprite.animation, $Sprite.frame)
		ghost.flip_h = $Sprite.flip_h
		ghost.modulate = Color(1, 1, 1, 0.5)
		ghost_timer = 0.0
