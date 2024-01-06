extends Resource

class_name CharacterInfo

@export var thumbnail_path: String
@export var name: String
@export var vehicle_path: String

func _to_string():
	return "%s (CharacterInfo)" % name
