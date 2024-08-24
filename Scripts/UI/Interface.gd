extends Node

@onready var Health: int = $"../HP".HEALTH
@onready var Health_Max: int = $"../HP".MAX_HEALTH
@onready var health_node: Node2D = $"../HP"
@onready var Health_Bar: TextureProgressBar = $Health_bar
@onready var Health_Value_Label: Label = $Health_value
@onready var Label_holder: Control = $Health_bar/placeholder
@onready var Cooldown_Bar: TextureProgressBar = $cooldown_bar
@onready var Duration_Bar: TextureProgressBar = $duration_bar
@onready var Coins_Label: Label = $Coins
@onready var Options_Panel: Control = $Options
@onready var Skill_Icons: PanelContainer = $cooldown_bar/Icons
@onready var Ability_node: Node2D = $"../Ability"

func _ready() -> void:
	Health_Bar.max_value = Health_Max
	Cooldown_Bar.value = 0
	Duration_Bar.value = 0

func _process(_delta: float) -> void:
	# Handle pausing when not paused
	if Input.is_action_just_pressed("ui_pause"):
		get_tree().paused = true # process set to "when paused" at options node
		Options_Panel.visible = true
	
	Coins_Label.text = str(SingletonBools.Coins)
	
	if Health:
		Health_Max = health_node.MAX_HEALTH
		Health = health_node.HEALTH
		Health_Bar.max_value = Health_Max
		Health_Bar.size.x = Health_Max
		Health_Bar.value = Health
		# Label settings
		Health_Value_Label.text = str(Health) + "/" + str(Health_Max)
		Health_Value_Label.global_position = Label_holder.global_position
	
	# Skill cooldown timer
	var cooldown: float = Ability_node.get_remaining_cooldown()
	var cooldown_time: float = Ability_node.get_cooldown_value() # get cooldown max value to subtract it
	Cooldown_Bar.value = cooldown * Cooldown_Bar.max_value / cooldown_time
	# Unfocus the skill icon during cooldown
	if Cooldown_Bar.value != 0:
		Skill_Icons.modulate = Color(1, 1, 1, 0.45)
	else:
		Skill_Icons.modulate = Color(1, 1, 1, 1)
	
	# Skill duration timer
	var duration: float = Ability_node.get_remaining_duration()
	var duration_time: float = Ability_node.get_duration_value() # get duration max value to subtract it
	Duration_Bar.value = duration * Duration_Bar.max_value / duration_time
