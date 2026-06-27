extends PanelContainer
class_name KeySlot

signal change

@onready var action_name_label: Label = %ActionNameLabel
@onready var bind_button: Button = %BindButton

var action_name: StringName
var rebinding: bool = false
var bind_device: String

func _ready() -> void:
	init("move_down", InputHelper.DEVICE_KEYBOARD)
	_connect_signal()

func init(_action_name: String, device: String = InputHelper.DEVICE_KEYBOARD) -> void:
	action_name_label.text = tr(_action_name)
	action_name = _action_name
	bind_device = device
	match device:
		InputHelper.DEVICE_KEYBOARD:
			bind_button.text = _get_action_text_keyboard(_action_name)
		InputHelper.DEVICE_XBOX_CONTROLLER:
			bind_button.text = _get_action_text_controller(_action_name)
		_:
			pass

func _unhandled_input(event: InputEvent) -> void:
	if not rebinding:
		return
	match bind_device:
		InputHelper.DEVICE_KEYBOARD:
			_rebind_keyboard(event)
		InputHelper.DEVICE_XBOX_CONTROLLER:
			_rebind_controller(event)

func _rebind_keyboard(event: InputEvent) -> void:
	if (event is InputEventKey or event is InputEventMouseButton) and event.is_pressed():
		InputHelper.replace_keyboard_input_for_action(action_name, InputHelper.get_keyboard_input_for_action(action_name), event)
		bind_button.text = _get_action_text_keyboard(action_name)
		rebinding = false

func _rebind_controller(event: InputEvent) -> void:
	if event is InputEventJoypadButton:
		# 处理手柄按钮 - replace 支持
		var old_input = InputHelper.get_joypad_input_for_action(action_name)
		InputHelper.replace_joypad_input_for_action(action_name, old_input, event)
		bind_button.text = _get_action_text_controller(action_name)
		rebinding = false

	elif event is InputEventJoypadMotion:
		# 处理摇杆/扳机 - 使用 set 方法代替
		InputHelper.set_joypad_input_for_action(action_name, event)
		bind_button.text = _get_action_text_controller(action_name)
		rebinding = false

## 键鼠文本
func _get_action_text_keyboard(action: String) -> String:
	var input = InputHelper.get_keyboard_input_for_action(action)
	return InputHelper.get_label_for_input(input)

## 手柄文本
func _get_action_text_controller(action: String) -> String:
	var input = InputHelper.get_joypad_input_for_action(action)
	return InputHelper.get_label_for_input(input)

func _on_bind_button_pressed() -> void:
	rebinding = true
	bind_button.grab_focus()
	bind_button.text = tr("请按下一个按键...")
	change.emit()

func update() -> void:
	match bind_device:
		InputHelper.DEVICE_KEYBOARD:
			bind_button.text = _get_action_text_keyboard(action_name)
		InputHelper.DEVICE_XBOX_CONTROLLER:
			bind_button.text = _get_action_text_controller(action_name)

func _connect_signal() -> void:
	bind_button.pressed.connect(_on_bind_button_pressed)
