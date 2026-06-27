extends Control

@onready var volume: MarginContainer = %Volume
@onready var graphic: MarginContainer = %Graphic
@onready var gameplay: MarginContainer = %Gameplay
@onready var control: MarginContainer = %Control

@onready var save_settings_button: Button = %SaveSettingsButton
@onready var reset_settings_button: Button = %ResetSettingsButton
@onready var close_button: Button = %CloseButton
@onready var tab_container: TabContainer = %TabContainer

@onready var volume_tab: Button = %VolumeTab
@onready var graphic_tab: Button = %GraphicTab
@onready var gameplay_tab: Button = %GameplayTab
@onready var control_tab: Button = %ControlTab


@export_file_path("*.tscn") var confirmation_window_scene: String

var is_change: bool = false:
	set(value):
		is_change = value
		save_settings_button.disabled =  not value

func _ready() -> void:
	save_settings_button.disabled = true
	_connect_signal()

func _change_settings() -> void:
	is_change = true


func update() -> void:
	volume.update()
	graphic.update()
	gameplay.update()
	control.update()

func _on_save_settings_button_pressed() -> void:
	GameSystem.settings.save_config()
	is_change = false
	save_settings_button.disabled = true

func _on_reset_settings_button_pressed() -> void:
	GameSystem.settings.reset_to_default()
	is_change = true
	update()

func _on_close_button_pressed() -> void:
	if not is_change:
		queue_free()
	else:
		var confirm_window_scene: PackedScene = load(confirmation_window_scene)
		var confirm_window: ConfirmationWindow = confirm_window_scene.instantiate()
		add_child(confirm_window)
		confirm_window.title_label.text = tr("设置未保存")
		confirm_window.tip_label.text = tr("是否保存设置")
		confirm_window.cancel_button.text = tr("取消")
		confirm_window.confirm_button.text = tr("保存")
		confirm_window.cancel_button.pressed.connect(_on_confirm_window_cancel_button_pressed)
		confirm_window.confirm_button.pressed.connect(_on_confirm_window_confirm_button_pressed)

func _on_confirm_window_cancel_button_pressed() -> void:
	GameSystem.settings.load_config()
	queue_free()

func _on_confirm_window_confirm_button_pressed() -> void:
	GameSystem.settings.save_config()
	queue_free()

func _tab_change(index: int) -> void:
	tab_container.current_tab = index

func _connect_signal() -> void:
	volume.change_settings.connect(_change_settings)
	graphic.change_settings.connect(_change_settings)
	gameplay.change_settings.connect(_change_settings)
	control.change_settings.connect(_change_settings)

	save_settings_button.pressed.connect(_on_save_settings_button_pressed)
	reset_settings_button.pressed.connect(_on_reset_settings_button_pressed)
	close_button.pressed.connect(_on_close_button_pressed)

	volume_tab.pressed.connect(_tab_change.bind(0))
	graphic_tab.pressed.connect(_tab_change.bind(1))
	gameplay_tab.pressed.connect(_tab_change.bind(2))
	control_tab.pressed.connect(_tab_change.bind(3))
