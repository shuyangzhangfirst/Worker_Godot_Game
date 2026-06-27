extends Node
class_name GunFireMode

signal shoot_bullet

@export var fire_mode_name: String = ""	## 开火模式名称

func _ready() -> void:
	_init_fire_mode()

func on_trigger_just_pressed() -> void:
	pass

func on_trigger_just_release() -> void:
	pass

## 返回开火模式名称
func get_fire_mode_name_string() -> String:
	return fire_mode_name

func _init_fire_mode() -> void:
	pass
