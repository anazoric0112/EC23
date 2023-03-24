extends Node

var players = []

func register_player(player : Player):
	players.append(player)

func all_shoot(direction):
	for player in players:
		player.shoot(direction)

