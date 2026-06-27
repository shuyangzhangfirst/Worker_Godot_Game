class_name Settings
extends Node

@onready var volume_setting: VolumeSetting = %VolumeSetting
@onready var graphic_setting: GraphicSetting = %GraphicSetting
@onready var gameplay_setting: GameplaySetting = %GameplaySetting
@onready var control_setting: ControlSetting = %ControlSetting

## 是否已初始化
var is_init: bool = false

## 保存路径
const SAVE_PATH: String = "user://config.ini"

func _ready() -> void:
	load_config()
	is_init = true

## 保存设置
func save_config() -> void:
	var config_file: ConfigFile = ConfigFile.new()

	volume_setting.save_config(config_file)
	graphic_setting.save_config(config_file)
	gameplay_setting.save_config(config_file)
	control_setting.save_config(config_file)

	config_file.save(SAVE_PATH)

## 加载设置
func load_config() -> void:
	var config_file: ConfigFile = ConfigFile.new()
	if config_file.load(SAVE_PATH) != OK:
		push_warning("未找到设置文件,重置为默认设置")
		reset_to_default()
		save_config()
	else:
		volume_setting.load_config(config_file)
		graphic_setting.load_config(config_file)
		gameplay_setting.load_config(config_file)
		control_setting.load_config(config_file)

## 重置游戏设置
func reset_to_default() -> void:
	volume_setting.reset_to_default()
	graphic_setting.reset_to_default()
	gameplay_setting.reset_to_default()
	control_setting.reset_to_default()
