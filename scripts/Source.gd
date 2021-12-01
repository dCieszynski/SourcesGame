extends StaticBody2D

var energy = 0
var health = 15
export (int) var max_energy

signal energy_full
signal get_source_health

var hit_sound = preload("res://assets/sounds/sourcehit.wav")

func _ready():
	emit_signal("get_source_health", health)

func _process(delta):
	if (energy == max_energy):
		emit_signal("energy_full")
		energy = 0

func _on_EnergyTimer_timeout():
	energy += 1;


func _on_Area2D_body_entered(body):
	if body.is_in_group("enemy"):
		if health > 0:
			health -= 1
			$AudioStreamPlayer2D.stream = hit_sound
			$AudioStreamPlayer2D.play()
			$AnimationPlayer.play("hit")
			emit_signal("get_source_health", health)
