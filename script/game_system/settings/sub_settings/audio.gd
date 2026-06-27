extends Node
class_name VolumeSetting

## 默认音量配置
const DEFAULT_MASTER: float = 0.7
const DEFAULT_BGM: float = 0.7
const DEFAULT_SFX: float = 0.7
const DEFAULT_ENV: float = 0.7
const DEFAULT_EFF: float = 0.7

#region 音频变量
@export var master_volume: float = DEFAULT_MASTER:
	set(value):
		master_volume = clamp(value, 0.0, 1.0)
		set_volume(0, master_volume)

@export var bgm_volume: float = DEFAULT_BGM:
	set(value):
		bgm_volume = clamp(value, 0.0, 1.0)
		set_volume(1, bgm_volume)

@export var sfx_volume: float = DEFAULT_SFX:
	set(value):
		sfx_volume = clamp(value, 0.0, 1.0)
		set_volume(2, sfx_volume)

@export var env_volume: float = DEFAULT_ENV:
	set(value):
		env_volume = clamp(value, 0.0, 1.0)
		set_volume(3, env_volume)

@export var eff_volume: float = DEFAULT_EFF:
	set(value):
		eff_volume = clamp(value, 0.0, 1.0)
		set_volume(4, eff_volume)
#endregion

## 加载设置
func load_config(config_file: ConfigFile) -> void:
	master_volume = config_file.get_value("volume", "master", DEFAULT_MASTER)
	bgm_volume = config_file.get_value("volume", "bgm", DEFAULT_BGM)
	sfx_volume = config_file.get_value("volume", "sfx", DEFAULT_SFX)
	env_volume = config_file.get_value("volume", "env", DEFAULT_ENV)
	eff_volume = config_file.get_value("volume", "eff", DEFAULT_EFF)

## 保存音量设置
func save_config(config_file: ConfigFile) -> void:
	config_file.set_value("volume", "master", master_volume)
	config_file.set_value("volume", "bgm", bgm_volume)
	config_file.set_value("volume", "sfx", sfx_volume)
	config_file.set_value("volume", "env", env_volume)
	config_file.set_value("volume", "eff", eff_volume)

func reset_to_default() -> void:
	master_volume = DEFAULT_MASTER
	bgm_volume = DEFAULT_BGM
	sfx_volume = DEFAULT_SFX
	env_volume = DEFAULT_ENV
	eff_volume = DEFAULT_EFF

## 设置音量,value = [0, 1.0]
func set_volume(bus_index: int, value: float) -> void:
	if bus_index >= AudioServer.bus_count:
		push_warning("音量bus配置越界:" + str("bus_index"))
		return
	var db: float = linear_to_db(value)
	AudioServer.set_bus_volume_db(bus_index, db)

func get_volume(bus_index: int) -> float:
	match bus_index:
		0:
			return master_volume
		1:
			return bgm_volume
		2:
			return sfx_volume
		3:
			return env_volume
		4:
			return eff_volume
		_:
			return 0.0
