extends Node

@onready var viewports: GridContainer = $Viewports

var PlayerViewport = preload("res://levels/player_viewport.tscn")
var Level = preload("res://levels/test.tscn")

var _level_instance: Node

func _ready():
	Global.connect("player_info_changed", _on_player_info_changed)
	_on_player_info_changed()

func _on_player_info_changed():
	_level_instance = Level.instantiate()
	add_child(_level_instance)
	
	for i in range(len(Global.player_info)):
		var info: PlayerInfo = Global.player_info[i]
		var carScene: PackedScene = load(info.character.vehicle_path)
		info.instance = carScene.instantiate()
		_level_instance.add_child(info.instance)
		info.instance.position += Vector3.LEFT * 3 * i
	
		var viewport: PlayerViewport = PlayerViewport.instantiate()
		
		viewport.initialize(_level_instance, Global.player_info[i])
		viewports.add_child(viewport)
	
	if viewports.get_child_count() > 1:
		viewports.columns = 2
	else:
		viewports.columns = 1

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://menus/select_characters_screen.tscn")

	for i in range(1,5):
		if Input.is_action_just_pressed("reset_player_%s" % i):
			_reset_player(i)

func _reset_player(idx: int):
	if idx > viewports.get_child_count() or idx <= 0:
		return
		
	idx -= 1
	
	var viewport: PlayerViewport = viewports.get_child(idx)
	viewport.player_info.instance.set_upright()
