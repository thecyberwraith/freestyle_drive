extends InputProfile

class_name JoystickInputProfile

var device: int

const FORWARD: JoyButton = JOY_BUTTON_A
const BACKWARD: JoyButton = JOY_BUTTON_X
const INTERACT: JoyButton = JOY_BUTTON_B

func _init(a_device: int=0):
	device = a_device

func get_steering() -> float:
	return Input.get_joy_axis(device, JOY_AXIS_LEFT_X)

func get_forward() -> float:
	if Input.is_joy_button_pressed(device, FORWARD):
		return 1.0
	return 0.0

func get_brake() -> float:
	if Input.is_joy_button_pressed(device, BACKWARD):
		return 1.0
	return 0.0

func get_interact() -> bool:
	return Input.is_joy_button_pressed(device, INTERACT)

func _to_string():
	return "Joystick %s" % device
