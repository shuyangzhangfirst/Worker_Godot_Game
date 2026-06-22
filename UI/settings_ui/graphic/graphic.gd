extends MarginContainer

signal change_settings

@onready var resolution_option_button: OptionButton = %ResolutionOptionButton
@onready var refresh_rate_option_button: OptionButton = %RefreshRateOptionButton
@onready var full_screen_check_button: CheckButton = %FullScreenCheckButton
@onready var vsync_check_button: CheckButton = %VsyncCheckButton

var graphic_setting: GraphicSetting

func _ready() -> void:
	graphic_setting = GameSystem.settings.graphic_setting
	_connect_signal()
	_fix_popup()
	_init_option_button()
	update()

#region 初始化
func _init_option_button() -> void:
	_init_resolution_option_button()
	_init_refresh_rate_option_button()

func _init_resolution_option_button() -> void:
	for key in graphic_setting.resolutions:
		resolution_option_button.add_item(key)

func _init_refresh_rate_option_button() -> void:
	for key in graphic_setting.refresh_rates:
		refresh_rate_option_button.add_item(key)
#endregion

#region 更新界面
func update() -> void:
	_update_resolution_option_button()
	_update_refresh_rate_option_button()
	_update_full_screen_check_button()
	_update_vsync_check_button()

func _update_resolution_option_button() -> void:
	var current_reslution: Vector2i = graphic_setting.resolution
	var key: String = graphic_setting.resolutions.find_key(current_reslution)
	for i in range(resolution_option_button.item_count):
		if resolution_option_button.get_item_text(i) == key:
			resolution_option_button.selected = i
			break

func _update_refresh_rate_option_button() -> void:
	var current_refresh_rate: int = graphic_setting.refresh_rate
	var key: String = graphic_setting.refresh_rates.find_key(current_refresh_rate)
	for i in range(refresh_rate_option_button.item_count):
		if refresh_rate_option_button.get_item_text(i) == key:
			refresh_rate_option_button.selected = i
			break

func _update_full_screen_check_button() -> void:
	var state: bool = graphic_setting.fullscreen
	full_screen_check_button.set_pressed_no_signal(state)
	resolution_option_button.disabled = state

func _update_vsync_check_button() -> void:
	var state: bool = graphic_setting.vsync
	vsync_check_button.set_pressed_no_signal(state)
	refresh_rate_option_button.disabled = state
#endregion


func _fix_popup() -> void:
	var option_buttons: Array[OptionButton]
	option_buttons.append(refresh_rate_option_button)
	option_buttons.append(resolution_option_button)

	for option_button in option_buttons:
		var popup: PopupMenu = option_button.get_popup()
		popup.canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST

func _on_resolution_option_button_item_selected(index: int) -> void:
	for key in graphic_setting.resolutions.keys():
		if key == resolution_option_button.get_item_text(index):
			graphic_setting.resolution = graphic_setting.resolutions[key]
			break
	change_settings.emit()

func _on_refresh_rate_option_button_item_selected(index: int) -> void:
	for key in graphic_setting.refresh_rates.keys():
		if key == refresh_rate_option_button.get_item_text(index):
			graphic_setting.refresh_rate = graphic_setting.refresh_rates[key]
			break

	change_settings.emit()

func _connect_signal() -> void:
	resolution_option_button.item_selected.connect(_on_resolution_option_button_item_selected)
	refresh_rate_option_button.item_selected.connect(_on_refresh_rate_option_button_item_selected)
	full_screen_check_button.toggled.connect(_on_full_screen_check_button_toggled)
	vsync_check_button.toggled.connect(_on_vsync_check_button_toggled)


func _on_full_screen_check_button_toggled(toggled_on: bool) -> void:
	graphic_setting.fullscreen = toggled_on
	_update_full_screen_check_button()

	change_settings.emit()

func _on_vsync_check_button_toggled(toggled_on: bool) -> void:
	graphic_setting.vsync = toggled_on
	_update_vsync_check_button()

	change_settings.emit()
