extends StaticBody2D
class_name Enemy

const Projectile = preload("res://Projectile.tscn")
var player

func _ready():
	$Timer.start()

func shoot(target_position):
	var projectile = Projectile.instance()
	get_parent().add_child(projectile)
	var projectile_direction = target_position - global_position
	projectile.direction = projectile_direction


func _on_Timer_timeout():
	shoot(player)
