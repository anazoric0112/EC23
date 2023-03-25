extends Area2D
class_name Enemy

const Projectile = preload("res://Projectile.tscn")
const PROJECTILE_DIST = 40
var player
var reload_time = 1500
var projectile_speed = 200
var max_hp = 30
var curr_hp = max_hp
var damage = 10
var body_damage = 40
var alive = true

func _ready():
	$Timer.wait_time = reload_time * 1.0 / 1000
	$Timer.start()
	GameRoomManager.enemy_count += 1

func shoot(target_position):
	var projectile = Projectile.instance()
	get_parent().add_child(projectile)
	var projectile_direction = target_position - global_position
	projectile_direction = projectile_direction.normalized()
	projectile.direction = projectile_direction
	projectile.global_position = global_position + projectile_direction * PROJECTILE_DIST
	projectile.speed = projectile_speed
	projectile.damage = damage
	projectile.set_collision_layer_bit(1, false)
	projectile.set_collision_layer_bit(3, true)

func _on_Timer_timeout():
	if player == null:
		return
	shoot(player.global_position)


func take_damage(damage):
	curr_hp -= damage
	if curr_hp <= 0:
		die()

func die():
	if not alive:
		return
	alive = false
	GameRoomManager.enemy_count -= 1
	print("Dead, enemy count: " + str(GameRoomManager.enemy_count))
	queue_free()

func _on_Enemy_body_entered(body):	
	if body.is_in_group("Projectiles"):
		body.on_hit(self)
	if body.is_in_group("Players"):
		body.take_damage(body_damage)
		body.invincible(0.5)
