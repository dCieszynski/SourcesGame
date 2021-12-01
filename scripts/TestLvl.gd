extends Node2D

var energyOrb_scene = load("res://scenes/EnergyOrb.tscn")

export var level = 1

export var enemies = [15, 10, 5]
var waves
var current_wave
var waves_cleared = false

var buildings

signal get_current_wave
signal get_source_health
signal get_level
signal win

func _ready():
	waves = enemies.size()
	current_wave = waves
	emit_signal("get_current_wave", current_wave, waves)
	emit_signal("get_level", level)

func _physics_process(delta):
	buildings = get_tree().get_nodes_in_group("building")
	if buildings.size() == 0:
		print("YOU LOSE!")
	if waves_cleared == true:
		var last_enemies = get_tree().get_nodes_in_group("enemy")
		if last_enemies.size() == 0:
			print("YOU WIN!")
			emit_signal("win")

func _on_Source_energy_full():
	var spawn_pos = $Source.global_position
	var energyOrb = energyOrb_scene.instance()
	energyOrb.global_position = spawn_pos
	add_child(energyOrb)

func _on_Spawner_enemies_spawned():
	current_wave -= 1
	emit_signal("get_current_wave", current_wave, waves)

func _on_Spawner_waves_cleared():
	waves_cleared = true

func _on_Source_get_source_health(health):
	emit_signal("get_source_health", health)


