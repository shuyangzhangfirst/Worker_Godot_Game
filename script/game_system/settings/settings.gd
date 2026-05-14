class_name SettingsManager extends Node

var is_init: bool = false

const SAVE_PATH: String = "user://Setting.ini"

@onready var audio: Node = $Audio
@onready var graphics: Node = $Graphics
@onready var game_play: Node = $GamePlay
@onready var control: Node = $Control

func _ready() -> void:
	load_settings()
	is_init = true

func load_settings() -> void:
	var config_file: ConfigFile = ConfigFile.new()
	if config_file.load(SAVE_PATH) != OK:
		push_warning("未找到设置文件,将新建默认配置")
		_save_all_settings()
		return
	
	audio.load_settings(config_file)
	graphics.load_settings(config_file)
	game_play.load_settings(config_file)
	control.load_settings(config_file)
	
	print("设置加载完成")

func save_all_settings() -> void:
	if not is_init:
		return
	_save_all_settings()

func _save_all_settings() -> void:
	var config_file: ConfigFile = ConfigFile.new()
	
	audio.save_all(config_file)
	graphics.save_all(config_file)
	game_play.save_all(config_file)
	control.save_all(config_file)
	
	config_file.save(SAVE_PATH)
	print("设置已保存")

func reset_to_default() -> void:
	audio.reset_to_default()
	graphics.reset_to_default()
	game_play.reset_to_default()
	control.reset_to_default()
	
	_save_all_settings()
	print("设置已重置为默认值")
