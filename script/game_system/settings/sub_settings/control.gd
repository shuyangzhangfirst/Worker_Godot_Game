extends Node
class_name ControlSetting

var actions: Array[StringName] = InputMap.get_actions().slice(91)

## 保存图像设置
func save_config(config_file: ConfigFile) -> void:
	for i in range(actions.size()):
		var data: String = InputHelper.serialize_inputs_for_action(actions[i])
		config_file.set_value("control", actions[i], data)

## 加载设置
func load_config(config_file: ConfigFile) -> void:
	for i in range(actions.size()):
		var data: String = config_file.get_value("control", actions[i], InputHelper.serialize_inputs_for_action(actions[i]))
		InputHelper.deserialize_inputs_for_action(actions[i], data)

func reset_to_default() -> void:
	InputHelper.reset_all_actions()
