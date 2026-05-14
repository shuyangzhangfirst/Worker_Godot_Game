extends Node

@onready var settings: SettingsManager = $".."

const DEFAULT_LANGUAGE: String = "zh_CN"
const DEFAULT_DIFFICULTY: int = 1

@export var language: String = DEFAULT_LANGUAGE:
	set(value):
		language = value
		_set_language()
		_save_language()

@export var difficulty: int = DEFAULT_DIFFICULTY:
	set(value):
		difficulty = value
		_set_difficulty()
		_save_difficulty()

# 语言设置
const LANGUAGES = {
	"简体中文": "zh_CN",
	"繁體中文": "zh_TW",
	"English": "en",
	"日本語": "ja",
}

const DIFFICULTIES = {
	"困难" = 0,
	"一般" = 1,
	"简单" = 2
}

func _ready() -> void:
	# 确保翻译服务已启用
	pass

## 设置语言
func _set_language() -> void:
	TranslationServer.set_locale(language)
	if settings.is_init:
		print("语言已切换为: %s" % language)

## 保存语言设置
func _save_language() -> void:
	if not settings.is_init:
		return
	var config_file = ConfigFile.new()
	if config_file.load(settings.SAVE_PATH) != OK:
		push_warning("未找到设置文件,将新建文件")
	config_file.set_value("game_play", "language", language)
	config_file.save(settings.SAVE_PATH)

## 设置难度
func _set_difficulty() -> void:
	if settings.is_init:
		print("游戏难度已设置为: %d" % difficulty)

## 保存难度设置
func _save_difficulty() -> void:
	if not settings.is_init:
		return
	var config_file = ConfigFile.new()
	if config_file.load(settings.SAVE_PATH) != OK:
		push_warning("未找到设置文件,将新建文件")
	config_file.set_value("game_play", "difficulty", difficulty)
	config_file.save(settings.SAVE_PATH)

## 加载设置
func load_settings(config_file: ConfigFile) -> void:
	language = config_file.get_value("game_play", "language", DEFAULT_LANGUAGE)
	difficulty = config_file.get_value("game_play", "difficulty", DEFAULT_DIFFICULTY)

## 保存全部
func save_all(config_file: ConfigFile) -> void:
	config_file.set_value("game_play", "language", language)
	config_file.set_value("game_play", "difficulty", difficulty)

## 重置为默认值
func reset_to_default() -> void:
	language = DEFAULT_LANGUAGE
	difficulty = DEFAULT_DIFFICULTY

## 获取语言显示名称
func get_language_display_name(locale: String) -> String:
	for display_name in LANGUAGES.keys():
		if LANGUAGES[display_name] == locale:
			return display_name
	return "简体中文"

## 获取难度显示名称
func get_difficulty_display_name(diff: int) -> String:
	for display_name in DIFFICULTIES.keys():
		if DIFFICULTIES[display_name] == diff:
			return display_name
	return "一般"
