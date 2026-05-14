extends Node

@onready var settings: SettingsManager = $".."

const DEFAULT_MASTER: float = 0.5
const DEFAULT_MUSIC: float = 0.5
const DEFAULT_SFX: float = 0.5
const DEFAULT_VOICE: float = 0.5
const DEFAULT_ENV: float = 0.5

#region 音频变量
## 主音频音量
@export var master_volume: float = DEFAULT_MASTER:
	set(value):
		master_volume = clamp(value, 0.0, 1.0)
		_set_volume(0, master_volume)
		_save_volume("master", master_volume)

## 音乐音量
@export var music_volume: float = DEFAULT_MUSIC:
	set(value):
		music_volume = clamp(value, 0.0, 1.0)
		_set_volume(1, music_volume)
		_save_volume("music", music_volume)

## 音效音量
@export var sfx_volume: float = DEFAULT_SFX:
	set(value):
		sfx_volume = clamp(value, 0.0, 1.0)
		_set_volume(2, sfx_volume)
		_save_volume("sfx", sfx_volume)

## 语音音量
@export var voice_volume: float = DEFAULT_VOICE:
	set(value):
		voice_volume = clamp(value, 0.0, 1.0)
		_set_volume(3, voice_volume)
		_save_volume("voice", voice_volume)

## 环境音量
@export var env_volume: float = DEFAULT_ENV:
	set(value):
		env_volume = clamp(value, 0.0, 1.0)
		_set_volume(4, env_volume)
		_save_volume("env", env_volume)
#endregion

func _ready() -> void:
	pass
	

## 设置音量
func _set_volume(bus_index:int, value: float) -> void:
	if bus_index >= AudioServer.bus_count:
		return
	var db: float = linear_to_db(value)
	AudioServer.set_bus_volume_db(bus_index, db)

## 保存音量
func _save_volume(bus_name: String, volume: float) -> void:
	if not settings.is_init:
		return
	var config_file = ConfigFile.new()
	if config_file.load(settings.SAVE_PATH) != OK:
		push_warning("未找到设置配置文件")
	config_file.set_value("volume", bus_name, volume)
	config_file.save(settings.SAVE_PATH)

## 加载设置
func load_settings(config_file: ConfigFile) -> void:
	master_volume = config_file.get_value("volume", "master", DEFAULT_MASTER)
	music_volume = config_file.get_value("volume", "music", DEFAULT_MUSIC)
	sfx_volume = config_file.get_value("volume", "sfx", DEFAULT_SFX)
	voice_volume = config_file.get_value("volume", "voice", DEFAULT_VOICE)
	env_volume = config_file.get_value("volume", "env", DEFAULT_ENV)

## 保存全部音量设置
func save_all(config_file: ConfigFile) -> void:
	config_file.set_value("volume", "master", master_volume)
	config_file.set_value("volume", "music", music_volume)
	config_file.set_value("volume", "sfx", sfx_volume)
	config_file.set_value("volume", "voice", voice_volume)
	config_file.set_value("volume", "env", env_volume)

## 重置为默认值
func reset_to_default() -> void:
	master_volume = DEFAULT_MASTER
	music_volume = DEFAULT_MUSIC
	sfx_volume = DEFAULT_SFX
	voice_volume = DEFAULT_VOICE
	env_volume = DEFAULT_ENV
