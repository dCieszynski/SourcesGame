extends Control

func _ready():
	if get_tree().paused == true:
		get_tree().paused = false

func _on_StartButton_pressed():
	get_tree().change_scene("res://scenes/Levels/Game1.tscn")

func _on_QuitButton_pressed():
	get_tree().quit()

func _on_HowToPlayButton_pressed():
	get_tree().change_scene("res://scenes/Tutorial.tscn")
