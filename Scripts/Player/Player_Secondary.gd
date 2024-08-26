extends Node

# Imports
@onready var body_node: Node2D = $".."
@onready var weapon_sprite: Sprite2D = $"../Weapon_sprite"
@onready var animation_node: AnimationPlayer = $"../Player_animation"
@onready var shield_collider: CollisionShape2D = $Shield/Collider
@onready var block_timer: Timer = $Block
@onready var camera: Camera2D = $"../Camera"

# Variables
var is_blocking: bool = false
var successful_parry: bool = false
var block_duration: float = 0.83 # times 1.8 the animation time
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	$Shield/Collider.disabled = true

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_secondary") and not body_node.current_state == body_node.player_state.HIT:
		if not is_blocking:
			
			# reset slide and dash if they had been cut
			body_node.is_dashing = false
			body_node.is_sliding = false
			
			body_node.current_state = body_node.player_state.PARRY
			shield_collider.disabled = false
			block_timer.start(block_duration)
			is_blocking = true

func _on_block_timeout() -> void:
	if animation_node.is_playing() and animation_node.current_animation == "hit_shield":
		# If animation is still playing, schedule the timeout to run after the animation ends
		await animation_node.animation_finished
		timeout()
	else:
		timeout()

func timeout() -> void:
	is_blocking = false
	successful_parry = false
	shield_collider.disabled = true
	body_node.reset_state()

func parry(delta: float) -> void:
	# Parry mechanics
	if successful_parry:
		animation_node.play("hit_shield")
		camera.shake(3.0, 10.0)
		_on_block_timeout() # avoid looping block animation
	else:
		animation_node.play("draw_shield")
	
	# Can parry while in the air but falls
	if not body_node.is_on_floor():
		body_node.velocity.y += (gravity + 500) * delta # more air duration = better feeling
		body_node.velocity.x *= 0.5 # fix bug to limit dash speed
		body_node.move_and_slide()
	
	weapon_sprite.visible = false

func _on_shield_area_entered(_area: Area2D) -> void:
	successful_parry = true
