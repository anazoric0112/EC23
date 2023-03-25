extends KinematicBody2D

var direction setget set_direction

var speed = 300
var damage = 40

func _ready():
	add_to_group("Projectiles")

func _physics_process(delta):
	var collision = move_and_collide(direction * delta * speed)
	if collision != null:
		on_hit(null)

func set_direction(dir):
	direction = dir
	look_at(global_position + dir)

func on_hit(target):
	if (target != null):
		target.take_damage(damage)
	queue_free()

func stop():
	direction = Vector2(0, 0)
