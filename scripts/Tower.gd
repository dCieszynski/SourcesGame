extends StaticBody2D

export var health = 3
var max_health

var hit_sound = preload("res://assets/sounds/towerhit.wav")
var expolsion = preload("res://scenes/BuildingExpolsion.tscn")

func _ready():
	$RegenTimer.start()
	max_health = health
	

func _on_Area2D_body_entered(body):
	if body.is_in_group("enemy"):
		health -= 1
		$AnimationPlayer.play("hit")
		$AudioStreamPlayer2D.stream = hit_sound
		$AudioStreamPlayer2D.play()
		$RegenTimer.stop()
		$RegenTimer.start()
		if health == 0:
			var effect = expolsion.instance()
			effect.global_position = global_position
			get_tree().current_scene.add_child(effect)
			queue_free()

func _on_RegenTimer_timeout():
	if health < max_health and health > 0:
		health += 1
