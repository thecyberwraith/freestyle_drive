extends Node3D

@onready var background_music: AudioStreamPlayer = $AudioStreamPlayer

func _ready():
	background_music.connect("finished", func(): background_music.play())
