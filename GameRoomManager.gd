extends Node

enum TYPE {
	FIRE, ICE, GRASS, WATER
}

const Rooms = [
	preload("res://Room.tscn")
]

var portals = []

var rooms = []

func generate_rooms(room_type):
	print("Generating rooms of type " + room_type)
	var room_left = Rooms[randi() % Rooms.size()].instance()
	var room_right = Rooms[randi() % Rooms.size()].instance()
	get_node("/root/Main").add_rooms(room_left, room_right)
