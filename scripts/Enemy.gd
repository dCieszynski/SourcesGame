extends KinematicBody2D

var buildings = []
var nearest_building
export var speed = 20
var starting_speed
var velocity
var dir

export var health = 5

var hit_sound = preload("res://assets/sounds/enemyhit.wav")
var explosion = preload("res://scenes/EnemyExplosion.tscn")

func _ready():
	starting_speed = speed
	
	buildings = get_tree().get_nodes_in_group("building")
	if is_instance_valid(buildings):
		nearest_building = buildings[0]
		for building in buildings:
			if building.global_position.distance_to(global_position) < nearest_building.global_position.distance_to(global_position):
				nearest_building = building
		dir = (nearest_building.global_position - global_position).normalized()
		velocity = dir * speed

func _physics_process(delta):
	if not is_instance_valid(nearest_building):
		buildings = get_tree().get_nodes_in_group("building")
		if buildings.size() != 0:
			nearest_building = buildings[0]
			for building in buildings:
				if building.global_position.distance_to(global_position) < nearest_building.global_position.distance_to(global_position):
					nearest_building = building
			dir = (nearest_building.global_position - global_position).normalized()
			velocity = dir * speed
		else:
			speed = 0
				
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.normal)
		$BounceTimer.start()

func _on_BounceTimer_timeout():
	velocity = dir * speed

func _on_HitboxArea_area_entered(area):
	if area.is_in_group("shot"):
		$AudioStreamPlayer2D.stream = hit_sound
		$AudioStreamPlayer2D.play()
		if health > 0:
			if area.is_in_group("blueShot"):
				health -= 1
			elif area.is_in_group("greenShot"):
				health -= 1
				speed = speed - (speed*0.3)
				velocity = dir * speed
				$SlowTimer.start()
			elif area.is_in_group("pinkShot"):
				health -= 2
			$AnimationPlayer.play("hit")
		else:
			var effect = explosion.instance()
			effect.global_position = global_position
			get_tree().current_scene.add_child(effect)
			queue_free()

func _on_SlowTimer_timeout():
	speed = starting_speed
	velocity = dir * speed

