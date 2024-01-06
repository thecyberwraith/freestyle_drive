extends Node

var player_info: Array[PlayerInfo] = []:
	get:
		return player_info
	set(value):
		player_info = value
		emit_signal("player_info_changed")

signal player_info_changed
