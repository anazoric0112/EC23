extends KinematicBody2D
class_name Player

signal died

const Projectile = preload("res://Projectile.tscn")
const PROJECTILE_DIST = 40

var velocity
var is_flipped = false
var speed = 300
var projectile_speed = 700
var damage = 50
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
	projectile.damage = damage
	projectile.global_position = global_position + direction * PROJECTILE_DIST
	$ShootingTimer.start()

func reduce_reload_time():
	$ShootingTimer.wait_time *= 0.9

func get_move_input():
	if dead:
		velocity = Vector2(0, 0)
		return
	velocity = Vector2()
	if Input.is_action_pressed("d"):
		is_flipped = false
		velocity.x += 1
	if Input.is_action_pressed("a"):
		is_flipped = true
		velocity.x -= 1
	if Input.is_action_pressed("s"):
		velocity.y += 1
	if Input.is_action_pressed("w"):
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
	blink_red()
	$HealthBar.value = curr_hp
	if curr_hp <= 0:
		dead = true
		emit_signal("died")
	print("OUCH I just took " + str(damage) + " damage")

func on_die():
	$AnimatedSprite.play("die")

func invincible(time):
	$InvincibleTimer.start(time)

func update_hp_bar():
	$HealthBar.max_value = max_hp
	$HealthBar.value = curr_hp

func blink_red():
	var duration = 0.25
	var num_blinks = 6
	var tween = Tween.new()
	add_child(tween)

	var start_color = Color(1, 1, 1, 1)
	var end_color = Color(1, 0, 0, 1)
	for i in range(num_blinks-1):
		tween.interpolate_property($AnimatedSprite, "modulate", start_color, end_color, duration/num_blinks, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		yield(tween, "tween_all_completed")
		tween.interpolate_property($AnimatedSprite, "modulate", end_color, start_color, duration/num_blinks, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		yield(tween, "tween_all_completed")
	remove_child(tween)
