extends Control

class_name ConsensusMenu

@onready var bar_container: HBoxContainer = $Panel/UserInputBars
@onready var consensus_bar: ProgressBar = $Panel/ConsensusBar

@export var input_bar_speed: float = 5.0
@export var confirmation_speed: float = 2.0

var bar_scene: PackedScene = preload("res://menus/shared_confirmation_bar.tscn")

var player_infos: Array[PlayerInfo]:
	get:
		return player_infos
	set(value):
		player_infos = value
		if is_node_ready():
			_setup_interface()

signal consensus_failed
signal consensus_achieved

func _ready():
	_setup_interface()

func _setup_interface():
	consensus_bar.value = 0.0
	
	for child in bar_container.get_children():
		remove_child(child)
		child.queue_free()
	
	for info in player_infos:
		var new_bar = bar_scene.instantiate()
		bar_container.add_child(new_bar)

func _process(delta):
	var total_forward: float = 0.0
	for i in range(bar_container.get_child_count()):
		var progress: ProgressBar = bar_container.get_child(i).get_child(0)
		var input: InputProfile = player_infos[i].input
		progress.value = lerp(progress.value, input.get_forward() - input.get_brake(), delta*input_bar_speed)
		total_forward += progress.value
	
	var average: float = total_forward / bar_container.get_child_count()
	average -= 1.1/(bar_container.get_child_count() + 1)
	average *= confirmation_speed
	consensus_bar.value = consensus_bar.value + average * delta
	
	if consensus_bar.value == -1.0:
		emit_signal("consensus_failed")
	elif consensus_bar.value == 1.0:
		emit_signal("consensus_achieved")
