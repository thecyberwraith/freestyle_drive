extends Resource

class_name CharacterInfo

@export_file("*.png") var thumbnail_path: String
@export var name: String
@export_file("*.tscn") var vehicle_path: String

func _to_string():
	return "%s (CharacterInfo)" % name
