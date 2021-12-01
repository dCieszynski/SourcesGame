extends Control

var level_path

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS

func _on_BackToMenuButton_pressed():
	get_tree().change_scene("res://scenes/Menu.tscn")

func _on_Restart_pressed():
	get_tree().change_scene(String(level_path))
