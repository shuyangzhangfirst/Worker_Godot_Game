extends Node2D

@export_file_path("*.tscn") var start_menu_scene: String
@export_file_path("*.tscn") var game_scene: String 

func _ready() -> void:
	_init_main_scene()

## 初始化主场景
func _init_main_scene() -> void:
	GameSystem.main_scene = self
