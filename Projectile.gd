extends KinematicBody2D

var direction setget set_direction

var speed = 1000

func _physics_process(delta):
	var collision = move_and_collide(direction * delta * speed)
	if collision != null:
		queue_free()
	

func set_direction(dir):
	direction = dir
	look_at(position + dir)
