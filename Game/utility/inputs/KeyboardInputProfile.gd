extends InputProfile

class_name KeyboardInputProfile

var forward: String = ''
var backward: String = ''
var left: String = ''
var right: String = ''
var interact: String = ''

@export var profile_index: int = 1:
	get:
		return profile_index
	set(value):
		profile_index = value
		forward = "profile%s_forward" % value
		backward = "profile%s_backward" % value
		left = "profile%s_left" % value
		right = "profile%s_right" % value
		interact = "profile%s_interact" % value

func _init(index: int = 1):
	profile_index = index

func get_forward() -> float:
	return Input.get_action_strength(forward)

func get_brake() -> float:
	return Input.get_action_strength(backward)

func get_steering() -> float:
	return Input.get_axis(left, right)

func get_interact_action() -> String:
	return interact
	
func _to_string() -> String:
	return "Keyboard Input %s" % profile_index
