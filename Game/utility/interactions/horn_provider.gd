extends InteractionProvider

class_name HornInteractionProvider

@export var sound: AudioStreamPlayer = null
@export var horn_delay: float = 1.0

func interaction_available(player_info: PlayerInfo) -> bool:
	return player_info.instance == get_parent()

func create_interaction(_player_info) -> Interaction:
	if sound == null:
		print("Warning: null sound in horn provider.")
		return
	
	return HornInteraction.new(sound, horn_delay)
