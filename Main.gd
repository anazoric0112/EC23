extends Node2D

var adding_rooms = false

func add_rooms(room_left, room_right):
	if adding_rooms:
		room_left.queue_free()
		room_right.queue_free()
		return
	adding_rooms = true
	$Tween.interpolate_property($ColorRect, "modulate:a", 0, 1, .5)
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
	$Tween.interpolate_property($ColorRect, "modulate:a", 1, 0, .5)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	adding_rooms = false

func generate_portals():
	for room in $Rooms.get_children():
		room.generate_portals()
