extends Interaction

class_name HornInteraction

var horn_delay: float = 2.0
var time_elapsed: float = -1.0

func _init(sound: AudioStreamPlayer, a_horn_delay: float):
	horn_delay = a_horn_delay
	sound.connect("finished", on_horn_finished)
	sound.play()

func on_horn_finished():
	time_elapsed = 0.0

func process_interaction(delta: float):
	if time_elapsed >= 0:
		time_elapsed += delta
	
	if time_elapsed > horn_delay:
		emit_signal("interaction_complete")
