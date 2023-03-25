extends Label


func _process(delta):
	text = "SCORE: " + str(GameRoomManager.score) + \
		 "\nLEVEL: " + str(GameRoomManager.level)
