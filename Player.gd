extends KinematicBody2D
class_name Player

signal died

const Projectile = preload("res://Projectile.tscn")
const PROJECTILE_DIST = 40

var velocity
var is_flipped = false
var speed = 400
var projectile_speed = 700
var max_hp = 500
var curr_hp = max_hp
var dead = false

func _ready():
	add_to_group("Players")
	Shooting.register_player(self)
	$HealthBar.max_value = max_hp
	$HealthBar.value = max_hp

func shoot(direction):
	var projectile = Projectile.instance()
	get_parent().add_child(projectile)
	projectile.direction = direction
	projectile.speed = projectile_speed
	projectile.global_position = global_position + direction * PROJECTILE_DIST
	$ShootingTimer.start()

func get_move_input():
	if dead:
		velocity = Vector2(0, 0)
		return
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
	if $ShootingTimer.time_left > 0 or dead:
		return
	var center = get_viewport_rect().get_center().x
	if global_position.x < center and direction.x < center:
		Shooting.all_shoot((direction - global_position).normalized())
	elif global_position.x > center and direction.x > center:
		Shooting.all_shoot((direction - global_position).normalized())

func _physics_process(_delta):
	if dead:
		return
	get_move_input()
	get_shoot_input()
	move_and_slide(velocity * speed)
	if velocity != Vector2(0, 0) and $AnimatedSprite.animation != "run":
		$AnimatedSprite.play("run")
	if velocity == Vector2(0, 0) and $AnimatedSprite.animation != "idle":
		$AnimatedSprite.play("idle")
	if velocity.x < 0 and !$AnimatedSprite.flip_h:
		$AnimatedSprite.flip_h = true
	if velocity.x > 0 and $AnimatedSprite.flip_h:
		$AnimatedSprite.flip_h = false

func _on_CollisionArea_body_entered(body):
	if body.is_in_group("Projectiles"):
		body.on_hit(self)

func take_damage(damage):
	if $InvincibleTimer.time_left > 0:
		return
	curr_hp -= damage
	invincible(.5)
	$HealthBar.value = curr_hp
	if curr_hp <= 0:
		dead = true
		emit_signal("died")
	print("OUCH I just took " + str(damage) + " damage")

func on_die():
	$AnimatedSprite.play("die")

func invincible(time):
	$InvincibleTimer.start(time)
