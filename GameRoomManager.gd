extends Node

enum TYPE {
	FIRE, ICE, GRASS, MOON
}

const Rooms = [
	preload("res://Room.tscn"),
	preload("res://Rooms/Room1.tscn"),
	preload("res://Rooms/Room2.tscn"),
	preload("res://Rooms/Room3.tscn"),
	preload("res://Rooms/Room4.tscn"),
	preload("res://Rooms/Room5.tscn")
]

var enemy_count = 0 setget set_enemy_count
var level = 0
var score = 0

var game_over = false

func generate_rooms(room_type):
	print("Generating rooms of type " + str(room_type))
	var room_left = Rooms[randi() % Rooms.size()].instance()
	var room_right = Rooms[randi() % Rooms.size()].instance()
	room_left.type = room_type
	room_right.type = room_type
	get_node("/root/Main").add_rooms(room_left, room_right)

func set_enemy_count(value):
	enemy_count = value
	if enemy_count == 0:
		level += 1
		get_node("/root/Main").upgrade_players()
		get_node("/root/Main").generate_portals()
		score += 100 + 25 * level
		print("LEVELUP")
