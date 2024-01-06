extends SubViewportContainer

class_name PlayerViewport

@onready var viewport: SubViewport = $SubViewport
@onready var camera: CarCamera = $SubViewport/CarCamera

var player_info: PlayerInfo = null
var input: InputProfile
var _init_world = null

func initialize(level: Node, an_info: PlayerInfo):
	_init_world = level
	player_info = an_info
	player_info.instance.input = player_info.input

func _ready():
	if not _init_world == null:
		viewport.world_3d = _init_world

	camera.car = player_info.instance
