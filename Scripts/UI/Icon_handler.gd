extends Control

# Ability icon nodes
@onready var icon_a: TextureRect = %Icon_a

# Skill icon nodes
@onready var icon_1: TextureRect = %Icon_1
@onready var icon_2: TextureRect = %Icon_2
@onready var icon_3: TextureRect = %Icon_3

# Variables
@export var data: Icons = preload("res://Resources/Icons_data/data.tres")

# List of icons
# var icons: Array = []

# func _ready() -> void:
# Initialize the list of icons
# icons = [icon_1, icon_2, icon_3]

# func _process(_delta: float) -> void:
# List of conditions and corresponding textures
# var conditions: Array = []
# if SingletonBools.Is_Thunder:
# conditions.append(data.texture_map["Thunder"])
# if SingletonBools.Is_Bleed:
# conditions.append(data.texture_map["Bleed"])
# if SingletonBools.Is_Bolt:
# conditions.append(data.texture_map["Bolt"])
# Assign textures to icons in order
# for i in range(min(icons.size(), conditions.size())):
# icons[i].texture = conditions[i]
