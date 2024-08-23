extends Node2D

var Near_player: bool = false
var player: Area2D = null

@onready var UI: CanvasLayer = $Popup/UI
@onready var Item_tab: NinePatchRect = $Popup/UI/Panel

func _process(_delta: float) -> void:
	
	if Near_player:
		if Input.is_action_just_pressed("ui_interact"):
			self.queue_free()
			
		if player:
			var converter: Transform2D = get_viewport().get_canvas_transform() # Global to Canvas position
			
			var tab_size_x: float = (Item_tab.size.x * 0.290) + 10
			var tab_size_y: float = Item_tab.size.y * 0.5
			
			var tab_pos_left: Vector2 = converter * (self.global_position + Vector2(10, -tab_size_y))
			var tab_pos_right: Vector2 = converter * (self.global_position + Vector2(-tab_size_x, -tab_size_y))
			
			if player.global_position < self.global_position:
				Item_tab.global_position = tab_pos_left
			else:
				Item_tab.global_position = tab_pos_right
			
		UI.visible = true
	else:
		UI.visible = false

func _on_collect_area_entered(area: Area2D) -> void:
	player = area
	if area.name == "Collector":
		Near_player = true

func _on_collect_area_exited(area: Area2D) -> void:
	player = null
	if area.name == "Collector":
		Near_player = false
