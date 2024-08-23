extends Node

# Variables
var can_attack = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Imports
@onready var cooldown_timer = $Cooldown
@onready var Body = $"../.."
@onready var animation = $"../../Animation"
@onready var attack_cooldown = $"../..".ATTACK_COOLDOWN

func _ready():
	$"../../Attack/Area/Collider".disabled = true

func attack(delta):
	# Attack state behavior
	if not Body.is_on_floor():
		Body.velocity.y += gravity * delta
		Body.move_and_slide()
	if can_attack:
		Body.rush()
		animation.play("attack")
		await animation.animation_finished
		Body.can_rush = false
		can_attack = false
		cooldown_timer.start(attack_cooldown)
	else:
		animation.play("idle")

func _on_cooldown_timeout():
	can_attack = true
