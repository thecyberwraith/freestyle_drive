extends Area3D

class_name Interactor

@export var player_info: PlayerInfo = null

var current_interaction: Interaction = null

func _process(delta):
	var interact_action: String = player_info.input.get_interact_action()
	
	if current_interaction == null:
		if InputMap.has_action(interact_action) and Input.is_action_just_pressed(interact_action):
			attempt_interaction()
	else:
		current_interaction.process_interaction(delta)

func attempt_interaction():
	if current_interaction != null and player_info == null:
		return
	
	var interactions: Array[InteractionProvider] = []
	
	for area in get_overlapping_areas():
		if area is InteractionProvider:
			interactions.append(area)

	interactions.filter(
		func(x: InteractionProvider): x.interaction_available(player_info)
	)
	
	if len(interactions) == 0:
		return
	
	var provider: InteractionProvider = interactions.reduce(
		func(x: InteractionProvider, m: InteractionProvider):
			if x.interaction_priority > m.interaction_priority:
				return x
			return m
	)
	
	current_interaction = provider.create_interaction(player_info)
	current_interaction.connect("interaction_complete", on_interaction_complete)

func on_interaction_complete():
	current_interaction.disconnect("interaction_complete", on_interaction_complete)
	current_interaction = null
