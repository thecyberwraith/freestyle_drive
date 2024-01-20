extends Control

const MAX_KEYBOARD_PROFILES: int = 2
const MAX_JOYSTICK_PROFILES: int = 4

@export var keyboard_profiles: Array[KeyboardInputProfile]

var PlayerSetupPanel = preload("res://menus/player_setup.tscn")
var ConsensusMenu = preload("res://menus/shared_confirmation.tscn")

# Maps from names (str) of input to the actual input
var used_profiles: Dictionary = {}
var process_input: bool = true

@onready var playerSetupPanelContainer = $Players
@onready var instructions = $Players/Instructions
@onready var version_label = $Version

func _ready():
	version_label.text = "Version %s" % Global.VERSION

func _input(event: InputEvent):
	if not process_input:
		return

	var joy_input: JoystickInputProfile = _get_as_joystick_input(event)
	if not joy_input == null:
		add_player(joy_input)
		
	keyboard_profiles.filter(
		func(x): return x.get_forward() > 0
		).map(func(x): add_player(x))

func _get_as_joystick_input(event: InputEvent) -> JoystickInputProfile:
	if not event is InputEventJoypadButton:
		return null
	
	var joy_event: InputEventJoypadButton = event

	if not joy_event.pressed:
		return null
	
	return JoystickInputProfile.new(joy_event.device)

func add_player(input: InputProfile):
	if input.name in used_profiles:
		return

	var panel: PlayerSetupPanel = PlayerSetupPanel.instantiate()
	panel.set_input_profile(input)
	panel.player_ready.connect(on_player_ready)
	panel.player_removed.connect(on_player_remove)
	
	used_profiles[input.name] = panel
	
	playerSetupPanelContainer.add_child(panel)
	playerSetupPanelContainer.move_child(instructions, -1)
	playerSetupPanelContainer.columns = 2
	
	set_player_numbers()

func on_player_ready(_player_setup: PlayerSetupPanel):
	for i in range(playerSetupPanelContainer.get_child_count()-1):
		if not playerSetupPanelContainer.get_child(i).is_player_ready:
			return
	
	for i in range(playerSetupPanelContainer.get_child_count()-1):
		var panel: PlayerSetupPanel = playerSetupPanelContainer.get_child(i)
		panel.process_input = false

	process_input = false

	var consensus: ConsensusMenu = ConsensusMenu.instantiate()
	consensus.player_infos = _get_player_infos()
	consensus.connect("consensus_achieved", _consensus_achieved)
	consensus.connect("consensus_failed", _consensus_failed)
	add_child(consensus)

func _consensus_achieved():
	Global.player_info = _get_player_infos()
	get_tree().change_scene_to_file("res://levels/game_scene.tscn")

func _consensus_failed():
	print("Consensus Failed")
	remove_child(get_child(-1))
	get_tree().create_timer(0.25)
	for panel in _get_player_panels():
		panel.process_input = true

	process_input = true

func _get_player_infos() -> Array[PlayerInfo]:
	var result: Array[PlayerInfo] = []
	for panel in _get_player_panels():
		result.append(panel.player_info)
	
	return result

func on_player_remove(player_setup: PlayerSetupPanel):
	playerSetupPanelContainer.remove_child(player_setup)
	used_profiles.erase(player_setup.input.name)
	
	if playerSetupPanelContainer.get_child_count() < 2:
		playerSetupPanelContainer.columns = 1
	
	set_player_numbers()

func set_player_numbers():
	for i in range(1, playerSetupPanelContainer.get_child_count()):
		playerSetupPanelContainer.get_child(i-1).set_player_number(i)

func _get_player_panels() -> Array[PlayerSetupPanel]:
	var result: Array[PlayerSetupPanel] = []
	for panel in playerSetupPanelContainer.get_children().filter(
		func(x): return x!=playerSetupPanelContainer.get_child(-1)
	):
		result.append(panel)
	
	return result
