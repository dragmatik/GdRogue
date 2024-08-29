extends TextureProgressBar

# Imports
@onready var HP: float = $"../../..".Health
@onready var HP_MAX: float = HP
@onready var sub_bar: TextureProgressBar = $sub_bar
@onready var HP_node: Node2D = $"../.."

func _ready() -> void:
	self.max_value = HP_MAX # drop value
	sub_bar.max_value = HP_MAX # real value

func _process(_delta: float) -> void:
	# Health bar placement
	var converter: Transform2D = get_viewport().get_canvas_transform() # Global to Canvas position
	var size_x: float = sub_bar.size.x * 0.145
	var get_pos: Vector2 = HP_node.global_position + Vector2(-size_x, 0)
	var set_pos: Vector2 = converter * get_pos
	self.global_position = set_pos
	
	# Info & Visibility
	HP = HP_node.enemy_health
	sub_bar.value = HP
	self.value = HP_node.enemy_health_drop
	if sub_bar.value == sub_bar.max_value:
		sub_bar.visible = false
		self.visible = false
	elif sub_bar.value == 0:
		sub_bar.visible = false
		self.visible = false
	else:
		sub_bar.visible = true
		self.visible = true

func show_damage(num: float, color: Color, font_size: float) -> void:
	# Label settings
	var damage_label: Label = Label.new()
	damage_label.text = str("%0.0f" % num)
	damage_label.position = Vector2(30, 30)
	damage_label.self_modulate = color
	damage_label.set("theme_override_font_sizes/font_size", font_size)
	add_child(damage_label)

	var fade_duration: float = 1
	var move_distance: float = 80
	# Create and configure the tween for fading
	var tween_fade: Tween = create_tween()
	tween_fade.tween_property(damage_label, "self_modulate", Color(1, 1, 1, 0), fade_duration)
	# Create and configure the tween for moving upwards
	var tween_move: Tween = create_tween()
	tween_move.tween_property(damage_label, "position", damage_label.position - Vector2(randf_range(-60, 60), move_distance), fade_duration)

	await tween_fade.finished
	await tween_move.finished
	damage_label.queue_free()
