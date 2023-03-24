extends StaticBody2D
class_name Enemy

const Projectile = preload("res://Projectile.tscn")
const PROJECTILE_DIST = 40
var player

func _ready():
	$Timer.start()

func shoot(target_position):
	var projectile = Projectile.instance()
	get_parent().add_child(projectile)
	var projectile_direction = target_position - global_position
	projectile_direction = projectile_direction.normalized()
	projectile.direction = projectile_direction
	projectile.global_position = global_position + projectile_direction * PROJECTILE_DIST

func _on_Timer_timeout():
	if player == null:
		return
	shoot(player.global_position)
