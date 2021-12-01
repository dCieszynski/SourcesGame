extends StaticBody2D

var starting_health
var health = 3

var explosion = preload("res://scenes/BuildingExpolsion.tscn")

func _ready():
	starting_health = health

func _on_Area2D_body_entered(body):
	if body.is_in_group("enemy"):
		if health == 0:
			queue_free()
		else:
			health -= 1
			$AnimationPlayer.play("hit")
			if health == 0:
				var effect = explosion.instance()
				effect.global_position = global_position
				get_tree().current_scene.add_child(effect)
				queue_free()
	if body.is_in_group("energyorb"):
		health += 4

func _on_Area2D_body_exited(body):
	if body.is_in_group("energyorb"):
		health = starting_health
