extends Node

enum TYPE {
	FIRE, ICE, GRASS, WATER
}

const Rooms = [
	preload("res://Room.tscn"),
	preload("res://Rooms/Room1.tscn"),
	preload("res://Rooms/Room2.tscn"),
	preload("res://Rooms/Room3.tscn"),
	preload("res://Rooms/Room4.tscn"),
	preload("res://Rooms/Room5.tscn")
]

var portals = []

var rooms = []

var enemy_count = 0 setget set_enemy_count

func generate_rooms(room_type):
	print("Generating rooms of type " + str(room_type))
	var room_left = Rooms[randi() % Rooms.size()].instance()
	var room_right = Rooms[randi() % Rooms.size()].instance()
	get_node("/root/Main").add_rooms(room_left, room_right)

func set_enemy_count(value):
	enemy_count = value
	if enemy_count == 0:
		get_node("/root/Main").generate_portals()
