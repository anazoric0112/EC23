extends KinematicBody2D
class_name Player

const Projectile = preload("res://Projectile.tscn")
const PROJECTILE_DIST = 40

var velocity
var is_flipped = false
var speed = 500
var can_shoot=true

func _ready():
	add_to_group("Players")
	Shooting.register_player(self)

func shoot(direction):
	var projectile = Projectile.instance()
	get_parent().add_child(projectile)
	projectile.direction = direction
	projectile.global_position = global_position + direction * PROJECTILE_DIST
	$Timer.start()

func get_move_input():
	velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		is_flipped = false
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		is_flipped = true
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	velocity = velocity.normalized()

func get_shoot_input():
	if Input.is_mouse_button_pressed(1):
		try_shoot(get_viewport().get_mouse_position())

func try_shoot(direction):
	if $Timer.time_left > 0:
		return
	var center = get_viewport_rect().get_center().x
	if global_position.x < center and direction.x < center:
		Shooting.all_shoot((direction - global_position).normalized())
	elif global_position.x > center and direction.x > center:
		Shooting.all_shoot((direction - global_position).normalized())

func _physics_process(_delta):
	get_move_input()
	get_shoot_input()
	move_and_collide(velocity * _delta * speed)

