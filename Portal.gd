extends Node2D

var room_type = GameRoomManager.TYPE.FIRE

signal player_entered
const fire_icon = preload("res://Pixels/Icons/fire_icon.png")
const ice_icon = preload("res://Pixels/Icons/ice_icon.png")
const grass_icon = preload("res://Pixels/Icons/grass_icon.png")
const moon_icon = preload("res://Pixels/Icons/moon_icon.png")

const fire = preload("res://Pixels/Fire/IceSet_w-2.png-1.png (2).png")
const ice = preload("res://Pixels/Ice/IceSet_ww-1.png.png")
const grass = preload("res://Pixels/Grass/New Piskel-10.png (2).png")
const moon = preload("res://Pixels/Moon/moondoor.png")

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
		GameRoomManager.TYPE.MOON:
			$Type.texture = moon_icon
	connect("player_entered", GameRoomManager, "generate_rooms")

func _on_Area2D_body_entered(body):
	if body.is_in_group("Players"):
		$AnimatedSprite.show()
		$AnimatedSprite.play("Explode")
		yield(get_tree().create_timer(.5), "timeout")
		emit_signal("player_entered", room_type)

func set_type(type):
	room_type = type

func get_sprite():
	return $Sprite

func set_old_type(type):
	match type:
		GameRoomManager.TYPE.FIRE:
			$Sprite.texture = fire
		GameRoomManager.TYPE.ICE:
			$Sprite.texture = ice
		GameRoomManager.TYPE.GRASS:
			$Sprite.texture = grass
		GameRoomManager.TYPE.MOON:
			$Sprite.texture = moon
