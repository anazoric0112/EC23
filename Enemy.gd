extends StaticBody2D
class_name Enemy

const Projectile = preload("res://Projectile.tscn")
const PROJECTILE_DIST = 40
var player
var reload_time = 100
var projectile_speed = 300
var max_hp = 500
var curr_hp = max_hp
var damage = 10

func _ready():
	$Timer.wait_time = reload_time * 1.0 / 1000
	$Timer.start()

func shoot(target_position):
	var projectile = Projectile.instance()
	get_parent().add_child(projectile)
	var projectile_direction = target_position - global_position
	projectile_direction = projectile_direction.normalized()
	projectile.direction = projectile_direction
	projectile.global_position = global_position + projectile_direction * PROJECTILE_DIST
	projectile.speed = projectile_speed
	projectile.damage = damage

func _on_Timer_timeout():
	if player == null:
		return
	shoot(player.global_position)

func _on_CollisionArea_body_entered(body):
	if body.is_in_group("Projectiles"):
		body.on_hit(self)
