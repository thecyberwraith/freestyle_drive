extends RefCounted

class_name Interaction

var player_info: PlayerInfo = null

signal interaction_complete

func _init(_player_info: PlayerInfo=null):
	print("Interaction created!")

func process_interaction(_delta: float):
	emit_signal("interaction_complete")
