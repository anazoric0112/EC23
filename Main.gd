extends Node2D

var adding_rooms = false

func _ready():
	GameRoomManager.generate_rooms(GameRoomManager.TYPE.ICE)

func add_rooms(room_left, room_right):
	if adding_rooms:
		room_left.queue_free()
		room_right.queue_free()
		return
	adding_rooms = true
	match room_left.type:
		GameRoomManager.TYPE.FIRE:
			$ColorRect.modulate = Color.red
		GameRoomManager.TYPE.ICE:
			$ColorRect.modulate = Color.blue
		GameRoomManager.TYPE.GRASS:
			$ColorRect.modulate = Color.green
		GameRoomManager.TYPE.MOON:
			$ColorRect.modulate = Color.burlywood
	$Tween.interpolate_property($ColorRect, "modulate:a", 0, 1, 1)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	for room in $Rooms.get_children():
		room.queue_free()
	room_left.global_position = Vector2(0, 0)
	room_left.set_player($PlayerLeft)
	$Rooms.call_deferred("add_child", room_left)
	room_right.global_position = Vector2(640, 0)
	room_right.set_player($PlayerRight)
	$Rooms.call_deferred("add_child", room_right)
	$Tween.interpolate_property($ColorRect, "modulate:a", 1, 0, 1)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	adding_rooms = false

func generate_portals():
	for room in $Rooms.get_children():
		room.generate_portals()

func upgrade_players():
	var type = $Rooms.get_child(0).type
	match type:
		GameRoomManager.TYPE.FIRE:
			print("Upgrading RELOAD")
			$PlayerLeft.reduce_reload_time()
			$PlayerRight.reduce_reload_time()
		GameRoomManager.TYPE.ICE:
			print("Upgrading DAMAGE")
			$PlayerLeft.damage += 20
			$PlayerRight.damage += 20
		GameRoomManager.TYPE.GRASS:
			print("Upgrading HP")
			$PlayerLeft.max_hp += 100
			$PlayerLeft.curr_hp += 100
			$PlayerLeft.update_hp_bar()
			$PlayerRight.max_hp += 100
			$PlayerRight.curr_hp += 100
			$PlayerRight.update_hp_bar()
		GameRoomManager.TYPE.MOON:
			print("Upgrading SPEED")
			$PlayerLeft.speed += 60
			$PlayerRight.speed += 60

func _on_PlayerLeft_died():
	game_over()

func _on_PlayerRight_died():
	game_over()

func game_over():
	$GameOver.visible = true
	$PlayerLeft.dead = true
	$PlayerRight.dead = true
	for room in $Rooms.get_children():
		for enemy in room.get_enemies():
			enemy.stop()
	$PlayerLeft.on_die()
	$PlayerRight.on_die()
