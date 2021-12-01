extends KinematicBody2D

var dir_x
var dir_y
var speed
var friction = 0.2
var velocity = Vector2.ZERO

var selected = false
var build_area = false
var build_area_position
var tower = false
var area_color

var energy = 10
var life_time = 3

var targets = []
var nearest_target
var instance
var shot = load("res://scenes/Shot.tscn")

var placed_sound = preload("res://assets/sounds/orbspawn.wav")
var shot_sound = preload("res://assets/sounds/shot.wav")
var dead_sound = preload("res://assets/sounds/orbdest.wav")

signal shoot
signal died

func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	dir_x = rng.randf_range(-10.0, 10.0)
	rng.randomize()
	dir_y = rng.randf_range(-10.0, 10.0)
	rng.randomize()
	speed = rng.randf_range(100.0, 200.0)

func _process(delta):
	velocity.x += dir_x
	velocity.y += dir_y
	velocity = velocity.normalized() * speed
	velocity = lerp(velocity, Vector2.ZERO, friction)
	velocity = move_and_slide(velocity)
	
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("energyorb"):
			emit_signal("died")
		if collision.collider.is_in_group("bottom"):
			emit_signal("died")
	
	if (friction >= 1):
		speed = 0
	if life_time <= 0:
		emit_signal("died")
	if energy <= 0:
		emit_signal("died")

func _physics_process(delta):
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	if selected == false and build_area == true:
		global_position = lerp(global_position, build_area_position, 10 * delta)
		if tower:
			if not is_instance_valid(nearest_target):
				if targets.size() > 0:
					nearest_target = targets[0]
					for target in targets:
						if is_instance_valid(target) and is_instance_valid(nearest_target):
							if target.global_position.distance_to(global_position) < nearest_target.global_position.distance_to(global_position):
								nearest_target = target
						$ShootTimer.start()
				else:
					$ShootTimer.stop()

func _on_FrictionTimer_timeout():
	friction += 0.1

func _on_Area2D_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click"):
		selected = true
		$LifeTimer.stop()
		$ShootTimer.stop()
		nearest_target = null
		targets = []

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			selected = false
			$LifeTimer.start()

func _on_Area2D_area_entered(area):
	$AudioStreamPlayer2D.stream = placed_sound
	$AudioStreamPlayer2D.play()
	build_area = true
	build_area_position = area.global_position
	life_time = 3
	if area.is_in_group("tower"):
		$EnergyTimer.start()
		tower = true
		targets += $AggroRange.get_overlapping_bodies()
		if area.is_in_group("blue"):
			area_color = "blue"
		elif area.is_in_group("green"):
			area_color = "green"
		elif area.is_in_group("pink"):
			area_color = "pink"

func _on_Area2D_area_exited(area):
	build_area = false
	$EnergyTimer.stop()
	$ShootTimer.stop()
	nearest_target = null
	targets = []
	tower = false

func _on_EnergyTimer_timeout():
	energy -= 1

func _on_LifeTimer_timeout():
	if selected == false and build_area == false:
		life_time -= 1

func _on_AggroRange_body_entered(body):
	if build_area == true and selected == false:
		if body.is_in_group("enemy"):
			targets.append(body)

func _on_AggroRange_body_exited(body):
	if build_area == true and selected == false:
		if body.is_in_group("enemy"):
			targets.erase(body)

func _on_ShootTimer_timeout():
	if is_instance_valid(nearest_target):
		instance = shot.instance()
		instance.set_target(nearest_target)
		instance.position = $Position2D.get_global_transform().origin
		if area_color == "blue":
			instance.modulate = Color(0, 0, 254)
		elif area_color == "green":
			instance.modulate = Color(81, 255, 0)
		elif area_color == "pink":
			instance.modulate = Color(255, 0, 254)
		$AudioStreamPlayer2D.stream = shot_sound
		$AudioStreamPlayer2D.play()
		get_parent().add_child(instance)


func _on_EnergyOrb_died():
	queue_free()
