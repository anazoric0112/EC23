extends Node2D

var room_type = GameRoomManager.TYPE.FIRE

signal player_entered

func _ready():
	room_type = GameRoomManager.TYPE.keys()[randi() % GameRoomManager.TYPE.size()]
	connect("player_entered", GameRoomManager, "generate_rooms")

func _on_Area2D_body_entered(body):
	if body.is_in_group("Players"):
		emit_signal("player_entered", room_type)
