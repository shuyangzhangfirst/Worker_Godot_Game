extends Node
class_name GameplaySetting

var default_language: String = "zh_CN"
var default_difficulty: int = 1

# 语言设置
var languages: Dictionary = {
	"简体中文": "zh_CN",
	"繁體中文": "zh_TW",
	"English": "en",
	"日本語": "ja",
}

var difficulties: Dictionary = {
	"困难" = 0,
	"一般" = 1,
	"简单" = 2
}

@export var language: String = default_language:
	set(value):
		language = value
		_set_language()

@export var difficulty: int = default_difficulty:
	set(value):
		difficulty = value
		_set_difficulty()

## 保存全部
func save_config(config_file: ConfigFile) -> void:
	config_file.set_value("game_play", "language", language)
	config_file.set_value("game_play", "difficulty", difficulty)

## 加载设置
func load_config(config_file: ConfigFile) -> void:
	language = config_file.get_value("game_play", "language", default_language)
	difficulty = config_file.get_value("game_play", "difficulty", default_difficulty)

## 重置为默认值
func reset_to_default() -> void:
	language = default_language
	difficulty = default_difficulty

## 设置语言
func _set_language() -> void:
	TranslationServer.set_locale(language)
	#print(TranslationServer.get_locale())

## 设置难度
func _set_difficulty() -> void:
	pass
