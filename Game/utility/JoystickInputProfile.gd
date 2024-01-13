extends InputProfile

class_name JoystickInputProfile

const FORWARD: JoyButton = JOY_BUTTON_A
const BACKWARD: JoyButton = JOY_BUTTON_X
const INTERACT: JoyButton = JOY_BUTTON_B

var profile: String
var steering_left: String
var steering_right: String
var forward: String
var backward: String
var interact: String

func _init(device: int=0):
	profile = "JoystickInputProfile(%s)" % device
	forward = "%s_forward" % profile
	backward = "%s_backward" % profile
	steering_left = "%s_steering_left" % profile
	steering_right = "%s_steering_right" % profile
	interact = "%s_interact" % profile
	if InputMap.has_action(forward):
		return
	
	_add_button(device, forward, JOY_BUTTON_A)
	_add_button(device, backward, JOY_BUTTON_X)
	_add_button(device, interact, JOY_BUTTON_B)
	
	var event = InputEventJoypadMotion.new()
	event.axis = JOY_AXIS_LEFT_X
	event.axis_value = 1.0
	InputMap.add_action(steering_right, 0.2)
	InputMap.action_add_event(steering_right, event)
	
	event = InputEventJoypadMotion.new()
	event.axis_value = -1.0
	InputMap.add_action(steering_left, 0.2)
	InputMap.action_add_event(steering_left, event)

func get_steering() -> float:
	return Input.get_axis(steering_left, steering_right)

func get_forward() -> float:
	return Input.get_action_strength(forward)

func get_brake() -> float:
	return Input.get_action_strength(backward)

func get_interact() -> bool:
	return Input.is_action_pressed(interact)

func _to_string():
	return profile

func _add_button(device: int, action: String, button: JoyButton):
	var event = InputEventJoypadButton.new()
	event.device = device
	event.button_index = button
	InputMap.add_action(action)
	InputMap.action_add_event(action, event)
