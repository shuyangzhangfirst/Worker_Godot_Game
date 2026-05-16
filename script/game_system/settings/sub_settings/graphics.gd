extends Node

@onready var settings: SettingsManager = $".."

const DEFAULT_RESOLUTION: Vector2i = Vector2i(1280, 720)
const DEFAULT_REFRESH_RATE: int = 120
const DEFAULT_VSYNC: bool = true
const DEFAULT_FULLSCREEN: bool = false

#region 图像设置变量
@export var resolution: Vector2i = DEFAULT_RESOLUTION:
	set(value):
		resolution = value
		_set_resolution()
		_save_resolution()

@export var refresh_rate: int = DEFAULT_REFRESH_RATE:
	set(value):
		refresh_rate = value
		_set_refresh_rate()
		_save_refresh_rate()
		
@export var vsync: bool = DEFAULT_VSYNC:
	set(value):
		vsync = value
		_set_vsync()
		_save_vsync()

@export var fullscreen: bool = DEFAULT_FULLSCREEN:
	set(value):
		fullscreen = value
		_set_fullscreen()
		_save_fullscreen()
#endregion
		
## 分辨率枚举
const RESOLUTIONS = {
	"2560x1440": Vector2i(2560, 1440),
	"1920x1080": Vector2i(1920, 1080),
	"1280x720": Vector2i(1280, 720),
}

## 刷新率限制
const REFRESH_RATES = {
	"30": 30,	#30Hz
	"60": 60,	#60Hz
	"120": 120,	#120Hz
	"144": 144,	#144Hz
	"无限制": 0	#无限制
}

## 设置窗口分辨率
func _set_resolution() -> void:
	if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_WINDOWED:
		if OS.is_debug_build():
			push_warning("非窗口模式下调整窗口分辨率")
		return
		
	DisplayServer.window_set_size(resolution)

	if OS.is_debug_build():
		print("窗口分辨率改为: %s" % resolution)

## 保存窗口分辨率设置
func _save_resolution() -> void:
	if not settings.is_init:
		return
	var config_file = ConfigFile.new()
	if config_file.load(settings.SAVE_PATH) != OK:
		push_warning("未找到设置文件,将新建文件")
	config_file.set_value("graphics", "resolution", resolution)
	config_file.save(settings.SAVE_PATH)

## 设置最大刷新率
func _set_refresh_rate() -> void:
	Engine.max_fps = refresh_rate

## 保存最大刷新率设置
func _save_refresh_rate() -> void:
	if not settings.is_init:
		return
	var config_file = ConfigFile.new()
	if config_file.load(settings.SAVE_PATH) != OK:
		push_warning("未找到设置文件,将新建文件")
	config_file.set_value("graphics", "refresh_rate", refresh_rate)
	config_file.save(settings.SAVE_PATH)

## 设置垂直同步
func _set_vsync():
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if vsync else DisplayServer.VSYNC_DISABLED)

## 保存垂直同步设置
func _save_vsync():
	if not settings.is_init:
		return
	var config_file = ConfigFile.new()
	if config_file.load(settings.SAVE_PATH) != OK:
		push_warning("未找到设置文件,将新建文件")
	config_file.set_value("graphics", "vsync", vsync)
	config_file.save(settings.SAVE_PATH)

## 设置全屏模式
func _set_fullscreen() -> void:
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(resolution)

## 保存全屏设置
func _save_fullscreen() -> void:
	if not settings.is_init:
		return
	var config_file = ConfigFile.new()
	if config_file.load(settings.SAVE_PATH) != OK:
		push_warning("未找到设置文件,将新建文件")
	config_file.set_value("graphics", "fullscreen", fullscreen)
	config_file.save(settings.SAVE_PATH)

## 加载设置
func load_settings(config_file: ConfigFile) -> void:
	resolution = config_file.get_value("graphics", "resolution", DEFAULT_RESOLUTION)
	refresh_rate = config_file.get_value("graphics", "refresh_rate", DEFAULT_REFRESH_RATE)
	vsync = config_file.get_value("graphics", "vsync", DEFAULT_VSYNC)
	fullscreen = config_file.get_value("graphics", "fullscreen", DEFAULT_FULLSCREEN)

## 保存全部图像设置
func save_all(config_file: ConfigFile) -> void:
	config_file.set_value("graphics", "resolution", resolution)
	config_file.set_value("graphics", "refresh_rate", refresh_rate)
	config_file.set_value("graphics", "vsync", vsync)
	config_file.set_value("graphics", "fullscreen", fullscreen)

## 重置为默认值
func reset_to_default() -> void:
	resolution = DEFAULT_RESOLUTION
	refresh_rate = DEFAULT_REFRESH_RATE
	vsync = DEFAULT_VSYNC
	fullscreen = DEFAULT_FULLSCREEN
