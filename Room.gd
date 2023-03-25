extends Node2D
class_name GameRoom

const Enemy = preload("res://Enemy.tscn")
const Portal = preload("res://Portal.tscn")

const ice_bg = preload("res://Pixels/Ice/ice_final.png")
const fire_bg = preload("res://Pixels/Fire/fire_final.png")
const grass_bg = preload("res://Pixels/Grass/grass_final.png")
const ice_wall = preload("res://Pixels/Ice/IceSet_w-2.png-1.png (1).png")
const fire_wall = preload("res://Pixels/Fire/New Piskel-3.png.png")
const grass_wall = preload("res://Pixels/Grass/lake4.png")
const ice_corner = preload("res://Pixels/Ice/IceSet_w-2.png-2.png.png")
const fire_corner = preload("res://Pixels/Fire/New Piskel-4.png.png")
const grass_corner = preload("res://Pixels/Grass/lake3.png")

const PORTAL_LOCATIONS = [
	Vector2(312, 696),
	Vector2(24, 312),
	Vector2(312, 24),
	Vector2(616, 312)
]

var num_monsters_min = 2
var num_monsters_max = 4
var difficulty = 1
var type = GameRoomManager.TYPE.FIRE setget set_type
var player

func _ready():
	spawn_enemies()

func spawn_enemies():
	var positions = $EnemyLocations.get_children()
	positions.shuffle()
	for i in range(randi() % (num_monsters_max - num_monsters_min + 1) + num_monsters_min):
		var enemy = spawn_enemy()
		if positions.size() > 0:
			enemy.position = positions[i].position
		else:
			enemy.position = Vector2(
				rand_range(40, 600),
				rand_range(40, 680)
			)

func spawn_enemy():
	var enemy = Enemy.instance()
	$Enemies.add_child(enemy)
	enemy.player = player
	enemy.set_type(type)
	return enemy

func generate_portals():
	var angle = 0
	for location in PORTAL_LOCATIONS:
		var portal = Portal.instance()
		call_deferred("add_child", portal)
		portal.set_old_type(type)
		portal.position = location
		portal.rotation_degrees = angle
		angle += 90
		if location.x > 312:
			portal.get_sprite().flip_h = true;

func set_player(new_player):
	player = new_player
	player.position = position + Vector2(320, 360)

func set_type(new_type):
	type = new_type
	match type:
		GameRoomManager.TYPE.FIRE:
			$Sprite.texture = fire_bg
		GameRoomManager.TYPE.ICE:
			$Sprite.texture = ice_bg
		GameRoomManager.TYPE.GRASS:
			$Sprite.texture = grass_bg
	for wall in $Walls.get_children():
		wall.set_type(new_type)
	for corner in $Corners.get_children():
		match type:
			GameRoomManager.TYPE.FIRE:
				corner.texture = fire_corner
			GameRoomManager.TYPE.ICE:
				corner.texture = ice_corner
			GameRoomManager.TYPE.GRASS:
				corner.texture = grass_corner
	for wall in $Idk.get_children():
		match type:
			GameRoomManager.TYPE.FIRE:
				wall.texture = fire_wall
			GameRoomManager.TYPE.ICE:
				wall.texture = ice_wall
			GameRoomManager.TYPE.GRASS:
				wall.texture = grass_wall

func get_enemies():
	return $Enemies.get_children()
