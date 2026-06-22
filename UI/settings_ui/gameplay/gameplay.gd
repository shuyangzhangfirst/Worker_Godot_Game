extends MarginContainer

signal change_settings

@onready var language_option_button: OptionButton = %LanguageOptionButton

var gameplay_setting: GameplaySetting

func _ready() -> void:
	gameplay_setting = GameSystem.settings.gameplay_setting
	_connect_signal()
	_fix_popup()
	_init_option_button()
	update()

#region 初始化
func _init_option_button() -> void:
	_init_language_option_button()

func _init_language_option_button() -> void:
	for key in gameplay_setting.languages.keys():
		language_option_button.add_item(key)
#endregion

#region 更新界面
func update() -> void:
	_update_language_option_button()

func _update_language_option_button() -> void:
	var current_language: String = gameplay_setting.language
	var key: String = gameplay_setting.languages.find_key(current_language)
	for i in range(language_option_button.item_count):
		if language_option_button.get_item_text(i) == key:
			language_option_button.selected = i
			break
#endregion


func _fix_popup() -> void:
	var option_buttons: Array[OptionButton]
	option_buttons.append(language_option_button)

	for option_button in option_buttons:
		var popup: PopupMenu = option_button.get_popup()
		popup.canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST

func _connect_signal() -> void:
	language_option_button.item_selected.connect(_on_language_option_button_item_selected)

func _on_language_option_button_item_selected(index: int) -> void:
	for key in gameplay_setting.languages.keys():
		if key == language_option_button.get_item_text(index):
			gameplay_setting.language = gameplay_setting.languages[key]
			break

	change_settings.emit()
