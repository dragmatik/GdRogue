extends CharacterBody2D

# Constants
const Total_Health = 1000
const Speed = 1.35

# Conditions
var can_attack = false
var can_cast = false
var is_detected = false

@onready var state_tree = $State_tree
@onready var state_machine = state_tree["parameters/playback"]

const rush = ["rush"]
const defeat = ["death"]
const slash = ["slash"]
const attacks = ["cast", "ready", "chase"]
const casts = ["power_up", "cancel"]

func _ready():
	$Attack/Area_1/Collider.disabled = true
	$Attack/Area_2/Collider.disabled = true

#### Start an attack ####

func start_attack():
	state_machine.travel(attacks.pick_random())

func idle_timer():
	if not can_attack:
		$Timers/Idle.start(1.5)
		can_attack = true

func _on_idle_timeout():
	start_attack()

func set_attack_false():
	can_attack = false

#### Rush attack ####

func rush_attack():
	state_machine.travel(rush.pick_random())

#### Slash ####

func slash_attack():
	if is_detected:
		state_machine.travel(slash.pick_random())

#### Hold cast ####

func cast_attack():
	state_machine.travel(casts.pick_random())

func cast_timer():
	if not can_cast:
		$Timers/Cast.start(1.85)
		can_cast = true

func _on_cast_timeout():
	cast_attack()

func set_cast_false():
	can_cast = false

#### Detect the player ####

var player 

func _on_vision_det_body_entered(body):
	player = body

func _on_vision_det_body_exited(_body):
	player = null

func _on_detect_body_entered(_body):
	is_detected = true

func _on_detect_body_exited(_body):
	is_detected = false

func _on_hitbox_area_entered(area):
	for meta_int in area.get_meta_list():
		if area.has_meta(meta_int):
			$HP.handle_damage(area.get_meta(meta_int), meta_int)
		
		if $HP.ENEMY_HEALTH <= 0:
			state_machine.travel(defeat.pick_random())
		
		elif $HP.ENEMY_HEALTH <= Total_Health * 0.5:
			print(1)
