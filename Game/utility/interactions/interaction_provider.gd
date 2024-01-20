extends Area3D

class_name InteractionProvider

@export_range(-1,100) var interaction_priority = 0

signal interaction_complete

func interaction_available(_player_info: PlayerInfo) -> bool:
	return false

func create_interaction(player_info: PlayerInfo) -> Interaction:
	return Interaction.new(player_info)
