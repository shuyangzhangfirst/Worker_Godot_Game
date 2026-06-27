extends Node
class_name GraphicSetting

## 刷新率限制
var refresh_rates: Dictionary = {
	"30": 30,	#30Hz
	"60": 60,	#60Hz
	"120": 120,	#120Hz
	"144": 144,	#144Hz
	"无限制": 0	#无限制
}

var resolutions: Dictionary = {
	"2560x1440": Vector2i(2560, 1440),
	"1920x1080": Vector2i(1920, 1080),
	"1280x720": Vector2i(1280, 720),
	"960x540": Vector2i(960, 540),
}

var default_resoluton: Vector2i = resolutions["1280x720"]
var default_refresh_rate: int = refresh_rates["120"]
var default_vsync: bool = false
var default_fullscreen: bool = false

#region 图像设置变量
@export var resolution: Vector2i = default_resoluton:
	set(value):
		resolution = value
		_set_resolution()

@export var refresh_rate: int = default_refresh_rate:
	set(value):
		refresh_rate = value
		_set_refresh_rate()

@export var fullscreen: bool = default_fullscreen:
	set(value):
		fullscreen = value
		_set_fullscreen()

@export var vsync: bool = default_vsync:
	set(value):
		vsync = value
		_set_vsync()
#endregion

## 加载设置
func load_config(config_file: ConfigFile) -> void:
	resolution = config_file.get_value("graphics", "resolution", default_resoluton)
	refresh_rate = config_file.get_value("graphics", "refresh_rate", default_refresh_rate)
	vsync = config_file.get_value("graphics", "vsync", default_vsync)
	fullscreen = config_file.get_value("graphics", "fullscreen", default_fullscreen)

## 保存图像设置
func save_config(config_file: ConfigFile) -> void:
	config_file.set_value("graphics", "resolution", resolution)
	config_file.set_value("graphics", "refresh_rate", refresh_rate)
	config_file.set_value("graphics", "vsync", vsync)
	config_file.set_value("graphics", "fullscreen", fullscreen)

func reset_to_default() -> void:
	resolution = default_resoluton
	refresh_rate = default_refresh_rate
	vsync = default_vsync
	fullscreen = default_fullscreen

## 设置窗口分辨率
func _set_resolution() -> void:
	if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_WINDOWED:
		push_warning("当前为非窗口模式，更改分辨率无效，请退出全屏后重试。")
		return
	var window: Window = get_window()
	window.size = resolution

	window.move_to_center()

func set_resolution(key: String) -> void:
	refresh_rate = resolutions[key]

## 设置最大刷新率
func _set_refresh_rate() -> void:
	Engine.max_fps = refresh_rate

func set_refresh_rate(key: String) -> void:
	refresh_rate = refresh_rates[key]

## 设置垂直同步
func _set_vsync():
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if vsync else DisplayServer.VSYNC_DISABLED)
	Engine.max_fps = 0 if vsync else refresh_rate


## 设置全屏模式
func _set_fullscreen() -> void:
	var window: Window = get_window()
	if fullscreen:
		window.mode = Window.MODE_EXCLUSIVE_FULLSCREEN
	else:
		window.mode = Window.MODE_WINDOWED
		_set_resolution()
