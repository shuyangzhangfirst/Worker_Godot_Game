extends Node2D
class_name BaseMap

@onready var env_color: CanvasModulate = $EnvColor	## 地图环境色调

@export var map_name: String = ""	## 地图名称
@export var map_music: AudioStream	## 地图音乐
@export var tilemap:TileMapLayer
## 地图事件数据
@export var map_data: Dictionary = {}

var map_path: String = scene_file_path

func _ready() -> void:
	_init_map()

func _init_map() -> void:
	GameSystem.audio.play_music(map_music)
