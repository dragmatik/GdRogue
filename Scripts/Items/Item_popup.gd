extends Control

# Containers
@onready var panel: NinePatchRect = $UI/Panel
@onready var v_container: VBoxContainer = $UI/Panel/VContainer

# Labels
@onready var name_label: Label = $UI/Panel/VContainer/HContainer/Name
@onready var type_label: Label = $UI/Panel/VContainer/Type
@onready var desc_label: Label = $UI/Panel/VContainer/Description
@onready var icon_label: TextureRect = $UI/Panel/VContainer/HContainer/icon
@onready var item_data: Node2D = $"../Data"

func _process(_delta: float) -> void:
	# Adjust Panel size on text length
	panel.size.y = v_container.size.y + 18
	# Get data
	name_label.text = str("  ") + item_data.item_name
	type_label.text = item_data.item_type
	desc_label.text = item_data.item_desc
	icon_label.texture = item_data.item_icon
