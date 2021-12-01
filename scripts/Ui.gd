extends Control

var current_level

var curent_wave
var max_wave

var source_health
var loseScreen = preload("res://scenes/EndScreen.tscn")

var level_path

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	if get_tree().paused == true:
		get_tree().paused =false
	$NinePatchRect/LevelInfo/LevelNumber.text = String(current_level)
	level_path = get_parent().filename

func _physics_process(delta):
	$NinePatchRect/WaveInfo/WaveXOf.text = String(curent_wave)
	$NinePatchRect/WaveInfo/WaveOfY.text = String(max_wave)
	
	$NinePatchRect/SourceHpInfo/SourceHp.text = String(source_health)
	
	if source_health == 0:
		get_tree().paused = true
		var lostUi = loseScreen.instance()
		lostUi.level_path = level_path
		get_tree().current_scene.add_child(lostUi)

func _on_Level_get_current_wave(wave, of_waves):
	curent_wave = wave
	max_wave = of_waves

func _on_Level_get_source_health(health):
	
	source_health = health

func _on_Level_get_level(level):
	current_level = level


func _on_PauseButton_pressed():
	if get_tree().paused == true:
		get_tree().paused = false
	else:
		get_tree().paused = true
