extends Resource

class_name InputProfile

var name: String:
	get:
		return _to_string()

func get_forward() -> float:
	return 0.0

func get_brake() -> float:
	return 0.0

func get_steering() -> float:
	return 0.0

func get_interact() -> bool:
	return false

func _to_string() -> String:
	return 'Generic Input'
