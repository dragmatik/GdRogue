extends Node2D

# Variables
var direction = 0
@onready var Parent = $".."
@onready var state_tree = $"../State_tree"
@onready var state_machine = state_tree["parameters/playback"]

#### Process ####

func _process(delta):
	if state_machine.is_playing():
		if state_machine.get_current_node() == "idle":
			stand(delta)
		elif state_machine.get_current_node() == "rush" or state_machine.get_current_node() == "rush_2":
			rush_attack()
		elif state_machine.get_current_node() == "chase":
			chase()

#### Basics #### 

func fall(delta):
	var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	Parent.velocity.y += gravity * delta
	Parent.move_and_slide()

func stand(delta):
	if not Parent.is_on_floor():
		fall(delta)
	else:
		Parent.velocity = Vector2.ZERO

func defeat():
	$Attack/Area_1/Collider.disabled = true
	$Attack/Area_2/Collider.disabled = true

func death():
	$"../..".queue_free()

#### Chase ####

func chase():
	if $"..".player:
		direction = $"..".player.global_position.x - $"../Sprite".global_position.x
		Parent.velocity.x = direction * $"..".Speed
	# Determine facing direction and adjust animations
	if direction > 0:
		$"../Sprite".flip_h = false
		$"../Attack/Area_1/Collider".position.x = 29
		$"../Attack/Area_2/Collider".position.x = -25
	elif direction < 0:
		$"../Sprite".flip_h = true
		$"../Attack/Area_1/Collider".position.x = -29
		$"../Attack/Area_2/Collider".position.x = 25
	Parent.move_and_slide()

#### Attacks ####

var can_rush = false
func rush_frame(): # on rush frame
	can_rush = true

var target = null
func target_player(): # on first frame
	if $"..".player: 
		target = $"..".player.global_position.x

func rush(): 
	if can_rush:
		direction = target - $"../Sprite".global_position.x
		Parent.velocity.x = direction * 6
		if direction > 0:
			$"../Sprite".flip_h = false
			$"../Attack/Area_1/Collider".position.x = 29
			$"../Attack/Area_2/Collider".position.x = -25
		elif direction < 0:
			$"../Sprite".flip_h = true
			$"../Attack/Area_1/Collider".position.x = -29
			$"../Attack/Area_2/Collider".position.x = 25
		Parent.move_and_slide()

func rush_attack():
	rush()

func finish_rush(): 
	can_rush = false
