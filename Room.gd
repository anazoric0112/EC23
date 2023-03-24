extends Node2D
class_name GameRoom

const Enemy = preload("res://Enemy.tscn")
const Portal = preload("res://Portal.tscn")

const PORTAL_LOCATIONS = [
	Vector2(300, 20),
	Vector2(300, 700),
	Vector2(20, 360),
	Vector2(620, 360)
]

var num_monsters = 3
var difficulty = 1
var type = GameRoomManager.TYPE.FIRE
var player

func _ready():
	spawn_enemies()
	generate_portals()

func spawn_enemies():
	for i in range(num_monsters):
		spawn_enemy()

func spawn_enemy():
	var enemy = Enemy.instance()
	$Enemies.add_child(enemy)
	enemy.position = Vector2(
		rand_range(40, 600),
		rand_range(40, 680)
	)
	enemy.player = player

func generate_portals():
	for location in PORTAL_LOCATIONS:
		var portal = Portal.instance()
		add_child(portal)
		portal.position = location

func set_player(new_player):
	player = new_player