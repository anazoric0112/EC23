extends Area2D
class_name Enemy

const Projectile = preload("res://Projectile.tscn")
const PROJECTILE_DIST = 40
var player
var reload_time = 1500 setget set_reload_time
var projectile_speed = 200
var max_hp = 30
var curr_hp = max_hp
var damage = 10
var body_damage = 40
var alive = true

var level = 0

func _ready():
	GameRoomManager.enemy_count += 1
	level = GameRoomManager.level

func set_reload_time(value):
	reload_time = value
	$Timer.wait_time = value
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
	projectile.set_collision_layer_bit(1, false)
	projectile.set_collision_layer_bit(3, true)

func _on_Timer_timeout():
	if player == null:
		return
	shoot(player.global_position)


func take_damage(damage):
	if !alive:
		return
	curr_hp -= damage
	$Explosions.show()
	$Explosions.play("on_hit")
	$HealthBar.value = curr_hp
	if curr_hp <= 0:
		die()

func die():
	if not alive:
		return
	alive = false
	GameRoomManager.score += 20 + 5 * level
	GameRoomManager.enemy_count -= 1
	print("Dead, enemy count: " + str(GameRoomManager.enemy_count))
	$Explosions.show()
	$Explosions.play("explode")

func _on_Enemy_body_entered(body):	
	if body.is_in_group("Projectiles"):
		body.on_hit(self)
	if body.is_in_group("Players") and !alive:
		body.take_damage(body_damage)

func stop():
	$Timer.stop()
	
func set_type(type):
	match type:
		GameRoomManager.TYPE.FIRE:
			self.reload_time = (rand_range(1200, 1500) - 50 * level) / 1000
			projectile_speed = 300
			max_hp = 60 + 10 * level
			curr_hp = max_hp
			damage = 15 + 2 * level
		GameRoomManager.TYPE.ICE:
			self.reload_time = (rand_range(1500, 1700) - 40 * level) / 1000
			projectile_speed = 250
			max_hp = 75 + 15 * level
			curr_hp = max_hp
			damage = 20 + 3 * level
		GameRoomManager.TYPE.GRASS:
			self.reload_time = (rand_range(1500, 2000) - 30 * level) / 1000
			projectile_speed = 200
			max_hp = 125 + 25 * level
			curr_hp = max_hp
			damage = 30 + 4 * level
	$HealthBar.max_value = max_hp
	curr_hp = max_hp
	$HealthBar.value = curr_hp

func _on_Explosions_animation_finished():
	if $Explosions.animation == "explode":
		queue_free()
	$Explosions.hide()
