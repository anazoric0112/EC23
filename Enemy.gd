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

var inverse_steering = false

const void_frames = preload("res://Void.tres")
const goblin_frames = preload("res://Goblin.tres")

var level = 0

func _ready():
	GameRoomManager.enemy_count += 1
	level = GameRoomManager.level
	$Sprite.play("Idle")

func set_reload_time(value):
	reload_time = value
	$Timer.start(value)

func shoot():
	$Sprite.speed_scale = 1.0 / (reload_time)
	print($Sprite.speed_scale)
	$Sprite.play("Shooting")


func _on_Timer_timeout():
	if player == null:
		return
	shoot()


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
			$Sprite.frames = goblin_frames
			self.reload_time = (rand_range(1500, 1700) - 40 * level) / 1000
			projectile_speed = 250
			max_hp = 75 + 15 * level
			curr_hp = max_hp
			damage = 20 + 3 * level
		GameRoomManager.TYPE.GRASS:
			$Sprite.frames = void_frames
			inverse_steering = true
			self.reload_time = (rand_range(1500, 2000) - 30 * level) / 1000
			projectile_speed = 200
			max_hp = 125 + 25 * level
			curr_hp = max_hp
			damage = 30 + 4 * level
		GameRoomManager.TYPE.MOON:
			self.reload_time = (rand_range(1000, 2000) - 40 * level) / 1000
			projectile_speed = int(rand_range(150, 350))
			max_hp = 75 + 20 * level
			curr_hp = max_hp
			damage = rand_range(15, 35) + 4 * level
	$HealthBar.max_value = max_hp
	curr_hp = max_hp
	$HealthBar.value = curr_hp

func _on_Explosions_animation_finished():
	if $Explosions.animation == "explode":
		queue_free()
	$Explosions.hide()


func _on_Sprite_animation_finished():
	if player == null or GameRoomManager.game_over:
		return
	if $Sprite.animation == "Idle":
		return
	var target_position = player.global_position
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
	$Sprite.play("Shooting")
	$Sprite.frame = 0

func _process(delta):
	if player == null:
		return
	if global_position.x - player.global_position.x < 0:
		if inverse_steering:
			$Sprite.flip_h = false
		else:
			$Sprite.flip_h = true 
	else:		
		if inverse_steering:
			$Sprite.flip_h = true
		else:
			$Sprite.flip_h = false
