extends Control

class_name PlayerSetupPanel

@onready var player_label: Label = $Margin/PlayerLabel
@onready var character_label: Label = $Margin/VBoxContainer/CharacterLabel
@onready var character_image: TextureRect = $Margin/VBoxContainer/CharacterImage
@onready var input_profile_label: Label = $Margin/InputProfileLabel

@export var options: Array[CharacterInfo]
@export var ChangeDelay: float = 0.25
@export var confirmed_color: Color = Color(1.0,0.0,0.0)

signal player_ready
signal player_removed

enum PlayerState {REMOVE, PENDING, CONFIRMED}

var is_player_ready: bool = false:
	get:
		return player_state == PlayerState.CONFIRMED

var process_input: bool = true

var input: InputProfile
var delay_input: float = 0

var character_idx: int = 0
var player_state: PlayerState = PlayerState.PENDING
var player_num: int = 1

var player_info: PlayerInfo:
	get:
		return PlayerInfo.new(
			input,
			options[character_idx],
			'Player %s' % player_num
		)

func _ready():
	delay_input = ChangeDelay
	_update_display()

func set_input_profile(new_input: InputProfile):
	input = new_input
	print("Setting input to %s" % new_input)
	_update_display()

func set_player_number(num: int):
	player_num = num
	_update_display()

func _update_display():
	if not is_node_ready():
		return
	
	player_label.text = "Player %s" % player_num
	input_profile_label.text = str(input)
	
	var option: CharacterInfo = options[character_idx]
	character_label.text = option.name
	character_image.texture = load(option.thumbnail_path)

func _process(delta):
	if not process_input:
		return

	if delay_input > 0 or player_state == PlayerState.REMOVE:
		delay_input -= delta
		return
	
	if player_state == PlayerState.PENDING:
		print(input.get_steering())
		if abs(input.get_steering()) > 0.5:
			character_idx += int(input.get_steering()/abs(input.get_steering()))
			character_idx = wrapi(character_idx, 0, len(options))
			_update_display()
			delay_input = ChangeDelay
			return
	
		if input.get_forward() > 0.5:
			player_state = PlayerState.CONFIRMED
			$Panel.modulate = confirmed_color
			emit_signal("player_ready", self)
			delay_input = ChangeDelay
			return
	
		if input.get_brake() > 0.5:
			player_state = PlayerState.REMOVE
			emit_signal("player_removed", self)
			return
	elif player_state == PlayerState.CONFIRMED:
		if input.get_forward() == 0.0:
			player_state = PlayerState.PENDING
			$Panel.modulate = Color(1.0,1.0,1.0,1.0)
			delay_input = ChangeDelay
			return
