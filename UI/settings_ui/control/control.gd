extends MarginContainer
@onready var tab_container: TabContainer = %TabContainer

signal change_settings

@onready var keyboard_container: VBoxContainer = %KeyboardContainer
@onready var controller_container: VBoxContainer = %ControllerContainer

@onready var keyboard_button: Button = %KeyboardButton
@onready var controller_button: Button = %ControllerButton

@export var key_slot_scene: PackedScene

var control_settings: ControlSetting

func _ready() -> void:
	init()
	_connect_signal()

func init() -> void:
	control_settings = GameSystem.settings.control_setting
	_init_keyboard_container()
	_init_controller_container()

func update() -> void:
	for slot in keyboard_container.get_children():
		slot.update()
	for slot in controller_container.get_children():
		slot.update()

func _init_keyboard_container() -> void:
	for action in control_settings.actions:
		var new_key_slot: KeySlot = key_slot_scene.instantiate()
		keyboard_container.add_child(new_key_slot)
		new_key_slot.init(action)
		new_key_slot.change.connect(_change_settings)

func _init_controller_container() -> void:
	for action in control_settings.actions:
		var new_key_slot: KeySlot = key_slot_scene.instantiate()
		controller_container.add_child(new_key_slot)
		new_key_slot.init(action, InputHelper.DEVICE_XBOX_CONTROLLER)
		new_key_slot.change.connect(_change_settings)

func _change_settings() -> void:
	change_settings.emit()

func _tab_change(index: int) -> void:
	tab_container.current_tab = index

func _connect_signal() -> void:
	keyboard_button.pressed.connect(_tab_change.bind(0))
	controller_button.pressed.connect(_tab_change.bind(1))
