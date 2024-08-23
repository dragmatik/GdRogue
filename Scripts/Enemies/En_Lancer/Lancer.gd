extends CharacterBody2D

# Constants
const HEALTH = 800
const SPEED = 1
const IDLE_SPEED = 90
const ATTACK_COOLDOWN = 1.5

# Collider Positions
var wall_raycast_position = 30
var ground_raycast_position = 30
var detection_collider_position = 105.5
var attack_collider_position = 29

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

var can_rush = false
func rush_frame(): # on rush frame
	can_rush = true

var target
func target_player(): # beginning to the attack
	if player: target = player.global_position.x

func rush(): 
	if can_rush:
		$States/Chase_state.direction = target - $Sprite.global_position.x
		velocity.x = $States/Chase_state.direction * 5
		# Determine facing direction and adjust animations
		if $States/Chase_state.direction > 0:
			$Sprite.flip_h = false
			$Movement/Wall.rotation = deg_to_rad(-90)
			$Movement/Wall.position.x = wall_raycast_position
			$Movement/Ground.position.x = ground_raycast_position
			$Detection/Collider.position.x = detection_collider_position
			$Attack/Area/Collider.position.x = attack_collider_position
		elif $States/Chase_state.direction < 0:
			$Sprite.flip_h = true
			$Movement/Wall.rotation = deg_to_rad(90)
			$Movement/Wall.position.x = -wall_raycast_position
			$Movement/Ground.position.x = -ground_raycast_position
			$Detection/Collider.position.x = -detection_collider_position
			$Attack/Area/Collider.position.x = -attack_collider_position
		move_and_slide()

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

func _on_hitbox_area_entered(_area):
	$HP.handle_damage()
	if $HP.enemy_health <= 0:
		enemy_is_dead = true
		current_state = enemy_state.DEAD  # Transition to death state
	else:
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
var ghost_scene = preload("res://Scenes/Effects/Ghost.tscn")
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
