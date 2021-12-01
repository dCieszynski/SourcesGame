extends Position2D

var enemies
var spawn_points = enemies
var current_wave
var rng = RandomNumberGenerator.new()
var spawning = false

export (PackedScene) var spawnling_scene1
export (PackedScene) var spawnling_scene2
export (PackedScene) var spawnling_scene3
export var wave_wait_time = 10

export var spawning_chances = [60, 75, 100]

signal enemies_spawned
signal waves_cleared

func _ready():
	$WaveTimer.wait_time = wave_wait_time
	$WaveTimer.start()

func _physics_process(delta):
	if spawning == true:
		while enemies > 0:
			rng.randomize()
			var pos_x = rng.randf_range(0, 1280)
			var pos_y = rng.randf_range(-180, 0)
			global_position.x = pos_x
			global_position.y = pos_y
			var rng_spawn = rng.randf_range(0, 100)
			if rng_spawn < 60:
				var spawnling = spawnling_scene1.instance()
				spawnling.global_position = global_position
				get_parent().add_child(spawnling)
				print("Spawn enemy in position: ", global_position)
				enemies -= 1
			elif rng_spawn >= 60 and rng_spawn < 75:
				var spawnling = spawnling_scene2.instance()
				spawnling.global_position = global_position
				get_parent().add_child(spawnling)
				print("Spawn enemy in position: ", global_position)
				enemies -= 1
			elif rng_spawn >= 75:
				var spawnling = spawnling_scene3.instance()
				spawnling.global_position = global_position
				get_parent().add_child(spawnling)
				print("Spawn enemy in position: ", global_position)
				enemies -= 1
			if enemies == 0:
				emit_signal("enemies_spawned")
				$WaveTimer.start()
				spawning = false


func _on_WaveTimer_timeout():
	current_wave = get_parent().current_wave
	enemies = get_parent().enemies[current_wave-1]
	if current_wave-1 >= 0:
		spawning = true
	else:
		emit_signal("waves_cleared")
