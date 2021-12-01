extends Area2D

var target = null
var speed = 200
var velocity

func _physics_process(delta):
	if is_instance_valid(target):
		velocity = (target.global_position - position).normalized() * speed
		position += velocity * delta
		rotation = velocity.angle()
	else:
		queue_free()

func set_target(new_target):
	target = new_target


func _on_Shot_body_entered(body):
	if body.is_in_group("enemy"):
		queue_free()


func _on_Shot_area_exited(area):
	if area.is_in_group("blue"):
		add_to_group("blueShot")
	elif area.is_in_group("green"):
		add_to_group("greenShot")
	elif area.is_in_group("pink"):
		add_to_group("pinkShot");
