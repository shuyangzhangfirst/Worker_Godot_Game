extends Node2D

func _ready() -> void:
	_init_main_scene()

## 初始化主场景
func _init_main_scene() -> void:
	GameSystem.main_scene = self
