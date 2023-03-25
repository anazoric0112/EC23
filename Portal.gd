extends Node2D

var room_type = GameRoomManager.TYPE.FIRE

signal player_entered
const fire_icon = preload("res://Pixels/Icons/IceSet-4.png.png")
const ice_icon = preload("res://Pixels/Icons/IceSet-5.png.png")
const grass_icon = preload("res://Pixels/Icons/IceSet-6.png.png")

func _ready():
	room_type = GameRoomManager.TYPE.values()[randi() % GameRoomManager.TYPE.size()]
	print(room_type)
	match room_type:
		GameRoomManager.TYPE.FIRE:
			$Type.texture = fire_icon
		GameRoomManager.TYPE.ICE:
			$Type.texture = ice_icon
		GameRoomManager.TYPE.GRASS:
			$Type.texture = grass_icon
	connect("player_entered", GameRoomManager, "generate_rooms")

func _on_Area2D_body_entered(body):
	if body.is_in_group("Players"):
		emit_signal("player_entered", room_type)

func get_sprite():
	return $Sprite
