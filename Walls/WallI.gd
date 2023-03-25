extends StaticBody2D

var fire = preload("res://Pixels/Fire/New Piskel-1.png.png")
var ice = preload("res://Pixels/Ice/IceSet_w-2.png.png")
var grass = preload("res://Pixels/Grass/lake1.png")

func set_type(type):
	match type:
		GameRoomManager.TYPE.FIRE:
			$Sprite.texture = fire
		GameRoomManager.TYPE.ICE:
			$Sprite.texture = ice
		GameRoomManager.TYPE.GRASS:
			$Sprite.texture = grass