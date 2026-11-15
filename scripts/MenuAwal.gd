extends Control

func _ready():
	if has_node("TombolStart"):
		$TombolStart.pressed.connect(_on_start_pressed)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		_on_start_pressed()

func _on_start_pressed():
	get_tree().change_scene_to_file("res://mapbaru.tscn")
