extends Control

var focus: bool = false

func _process(_delta: float) -> void:
	# Handle unpausing when "ui_parry" is pressed
	if Input.is_action_just_pressed("ui_parry"):
		get_tree().paused = false
		visible = false
		focus = false
	
	# Grab focus
	if visible and not focus:
		$Tab/items/a.grab_focus()
		focus = true
