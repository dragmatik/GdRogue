extends Control

# Skill nodes
@onready var icon_a: TextureRect = %Icon_ability # Ability nodes
@onready var icon_1: TextureRect = %Icon_1
@onready var icon_2: TextureRect = %Icon_2
@onready var icon_3: TextureRect = %Icon_3
@onready var icon_4: TextureRect = %Icon_4

# Variables
@export var data: Icons = preload("res://Resources/Icons_data/data.tres")

# Track the applied Icons as an array
var applied_icons: Array = []

func _process(_delta: float) -> void:
	# Ability Icons
	if SingletonBools.Ab_Is_Fire_ball: icon_a.texture = data.texture_map["Fire_ball"]
	if SingletonBools.Ab_Is_Force_field: icon_a.texture = data.texture_map["Force_field"]
	
	# Thunder
	if SingletonBools.Is_Thunder:
		if "Thunder" not in applied_icons:
			apply_texture("Thunder")
			applied_icons.append("Thunder")
	else:
		remove_texture("Thunder")

	# Bleed
	if SingletonBools.Is_Bleed:
		if "Bleed" not in applied_icons:
			apply_texture("Bleed")
			applied_icons.append("Bleed")
	else:
		remove_texture("Bleed")

	# Bolt
	if SingletonBools.Is_Bolt:
		if "Bolt" not in applied_icons:
			apply_texture("Bolt")
			applied_icons.append("Bolt")
	else:
		remove_texture("Bolt")

# Function to apply texture to the first available icon
func apply_texture(texture_name: String) -> void:
	var texture: Texture2D = data.texture_map[texture_name]
	if icon_1.texture == null:
		icon_1.texture = texture
	elif icon_2.texture == null:
		icon_2.texture = texture
	elif icon_3.texture == null:
		icon_3.texture = texture
	elif icon_4.texture == null:
		icon_4.texture = texture

# Function to remove texture from the icons and applied_icons array
func remove_texture(texture_name: String) -> void:
	# Remove from the applied_icons array
	if texture_name in applied_icons:
		applied_icons.erase(texture_name)
		# Find and set the corresponding icon's texture to null
		if icon_1.texture == data.texture_map[texture_name]:
			icon_1.texture = null
		elif icon_2.texture == data.texture_map[texture_name]:
			icon_2.texture = null
		elif icon_3.texture == data.texture_map[texture_name]:
			icon_3.texture = null
		elif icon_4.texture == data.texture_map[texture_name]:
			icon_4.texture = null
