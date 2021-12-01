extends Node

export (String) var next_scene_path

func _on_Level_win():
	get_tree().change_scene(next_scene_path)
