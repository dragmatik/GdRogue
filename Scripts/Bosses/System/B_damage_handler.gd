extends Node

# Base Variables
var ENEMY_HEALTH # Main health amount
var ENEMY_HEALTH_DROP # dynamic health decrease
var ENEMY_DAMAGED = 0

# Hit impact
var hit_scene = preload("res://Scenes/Effects/Textures/Hit_impact.tscn")
var get_hit

# Bleeding Variables
var BLEEDING_DMG = 2
var bleeding = false
var bleeding_duration = 2.0
var bleeding_elapsed_time = 0.0
var bleeding_interval = 0.1
var bleeding_timer = 0.0
var Claw = preload("res://Scenes/Effects/Textures/Claw.tscn")
var Blood = preload("res://Scenes/Effects/Particles/Blood.tscn")
var get_claw
var get_blood

# Thunder Variables
var thunder_scene = preload("res://Scenes/Skills/Ability_Thunder.tscn")
var thunder_on = false
var thunder_frequency = 0.2
var thunder_timer = 0.0
var get_thunder

# Thunder2 Variables
var Thunder2_scene = preload("res://Scenes/Skills/Ability_Thunder_2.tscn")
var Thunder2_on = false
var Thunder2_frequency = 2.4
var Thunder2_timer = 0.0
var get_Thunder2

func _ready():
	ENEMY_HEALTH = $"..".Total_Health
	ENEMY_HEALTH_DROP = ENEMY_HEALTH

func _process(delta):
	# HANDLE HEALTH DECREASE BAR
	if ENEMY_HEALTH_DROP > ENEMY_HEALTH:
		ENEMY_HEALTH_DROP += (ENEMY_HEALTH - ENEMY_HEALTH_DROP) * delta * 1.5
		if ENEMY_HEALTH_DROP <= ENEMY_HEALTH:
			ENEMY_HEALTH_DROP = ENEMY_HEALTH

	# HANDLE BLEEDING TIMER
	if bleeding:
		bleeding_timer += delta
		if bleeding_timer >= bleeding_interval:
			ENEMY_HEALTH -= BLEEDING_DMG
			bleeding_timer = 0.0
			bleeding_elapsed_time += bleeding_interval
			if bleeding_elapsed_time >= bleeding_duration:
				stop_bleeding()
	
	# HANDLE THUNDER EFFECT TIMER
	if thunder_on:
		thunder_timer += delta
		if thunder_timer >= thunder_frequency:
			stop_thunder()
		
	# HANDLE THUNDER EFFECT TIMER
	if Thunder2_on:
		Thunder2_timer += delta
		if Thunder2_timer >= Thunder2_frequency:
			stop_thunder2()

func handle_damage(value, type):
	# HANDLE BASE DAMAGE
	if type == "base_damage":
		ENEMY_DAMAGED = value
		ENEMY_HEALTH -= ENEMY_DAMAGED
		# hit impact effect
		get_hit = hit_scene.instantiate()
		get_parent().add_child(get_hit)
		get_hit.impact($"../Sprite".flip_h) # flip the directional impact effects
		get_hit.global_position = $"../Collider".global_position
		# Add impact effects and filter on damage
		$"../../../player/Camera".shake(5.0, 10.0)
		$"../Filter".play("Hit_effect")
	
	# HANDLE BLEEDING DAMAGE
	elif type == "Bleeding":
		if not bleeding and value:
			bleeding = true
			# show blood particle effect
			get_blood = Blood.instantiate()
			get_parent().add_child(get_blood)
			get_blood.global_position = $"../Collider".global_position
			get_blood.scale = $"../Sprite".scale
			# show claw icon effect
			get_claw = Claw.instantiate()
			get_parent().add_child(get_claw)
			get_claw.global_position = $"../Collider".global_position
			# get_claw.scale = $"../Sprite".scale
			# reset timer
			bleeding_elapsed_time = 0.0
			bleeding_timer = 0.0
	
	# HANDLE THUNDER DAMAGE
	elif type == "Thunder":
		if not thunder_on and value:
			thunder_on = true
			thunder_timer = 0.0 # Reset thunder timer
			get_thunder = thunder_scene.instantiate() # show particle effect
			get_parent().add_child(get_thunder)
			get_thunder.global_position = $"../Collider".global_position
			# get_thunder.scale = $"../Sprite".scale
	elif type == "bolt":
			ENEMY_DAMAGED = value
			ENEMY_HEALTH -= ENEMY_DAMAGED
			# Add impact effects and filter on damage
			$"../../../player/Camera".shake(5.0, 10.0)
			$"../Filter".play("Hit_effect")
	
	# HANDLE THUNDER DAMAGE
	elif type == "Thunder2":
		if not Thunder2_on and value:
			Thunder2_on = true
			Thunder2_timer = 0.0 # Reset Thunder2 timer
			get_Thunder2 = Thunder2_scene.instantiate() # show particle effect
			get_parent().add_child(get_Thunder2)
			get_Thunder2.global_position = $"../Collider".global_position
			# get_Thunder2.scale = $"../Sprite".scale
	elif type == "bolt_2":
			ENEMY_DAMAGED = value
			ENEMY_HEALTH -= ENEMY_DAMAGED
			# Add impact effects and filter on damage
			$"../../../player/Camera".shake(5.0, 10.0)
			$"../Filter".play("Hit_effect")

func stop_bleeding():
	get_blood.queue_free()
	bleeding = false
	bleeding_elapsed_time = 0.0
	bleeding_timer = 0.0

func stop_thunder():
	thunder_on = false
	thunder_timer = 0.0

func stop_thunder2():
	Thunder2_on = false
	Thunder2_timer = 0.0
