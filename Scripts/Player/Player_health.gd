extends Node

# Variables
var MAX_HEALTH: float = 100
var DAMAGE_TAKEN: float = 0
var Immune: bool = false
var Immunity_time: float = 2

# Imports
@onready var HEALTH: float = MAX_HEALTH # dynamic health (float for more precision)
@onready var body_node: Node2D = $".."
@onready var animation_node: AnimationPlayer = $"../Animation"
@onready var flash_effect: AnimationPlayer = $"../Flash"
@onready var immunity_timer: Timer = $Immunity
@onready var hitbox_collider: CollisionShape2D = $"../Hitbox/Collider"
@onready var block_node: Node2D = $"../Blocking"
@onready var curse_node: Node2D = $"../Curses"
@onready var camera: Camera2D = $"../Camera"

func _process(_delta: float) -> void:
	# Handle player death
	if HEALTH <= 0:
		body_node.current_state = body_node.player_state.DEAD
	if Immune:
		flash_effect.play("hit_flash")
		hitbox_collider.disabled = true # loops here so the hitbox stays off even after sliding

func death(delta: float) -> void:
	# Handle death animation and node removal
	if not body_node.is_on_floor():
		var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
		body_node.velocity.y += gravity * delta
		body_node.move_and_slide()
	animation_node.play("death")
	await animation_node.animation_finished
	body_node.queue_free()

func hit() -> void:
	animation_node.play("hit")
	camera.shake(2.5, 15.0)
	framefreeze()
	Immune = true
	immunity_timer.start(Immunity_time)

func _on_immunity_timeout() -> void:
	Immune = false
	hitbox_collider.disabled = false
	flash_effect.stop()

func _on_player_hitbox_area_entered(area: Area2D) -> void:
	# Handle damage when player hitbox is entered
	for meta_int in area.get_meta_list():
		if area.has_meta(meta_int):
			DAMAGE_TAKEN = area.get_meta(meta_int)
			if block_node.successful_parry:
				DAMAGE_TAKEN = 0 # if parry was successful, reduce to 0
			# If player was hit, change state
			if DAMAGE_TAKEN > 0 and not block_node.successful_parry and not HEALTH < 0:
				body_node.current_state = body_node.player_state.HIT
			HEALTH -= DAMAGE_TAKEN
			# Curse handler
			if not block_node.successful_parry:
				curse_node.handle_curses(area.get_meta(meta_int), meta_int)
			# make sure health doesn't drop below 0
			if HEALTH < 0:
				HEALTH = 0

func framefreeze() -> void:
	Engine.time_scale = 0
	await get_tree().create_timer(0.5, true, false, true).timeout
	Engine.time_scale = 1
