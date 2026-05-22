@tool
extends Interactor
class_name Teleporter

@export_file_path("*.tscn") var map_scene_path: String = "" 	## 地图场景路径
@export var target_entry_point: String = ""		## 新地图进入口

func interact() -> void:
	super.interact()
	_teleport_to_other_map(map_scene_path)
	
	
## 传送到另一个地图
func _teleport_to_other_map(new_map_path: String) -> void:
	if new_map_path == "":
		push_error("传送器[%s]的地图场景路径为空，请检查配置", interactor_name)
		return
	print("开始切换地图")
	GameSystem.scene_load.load_scene(map_scene_path)
	await EventBus.scene_load_finished
	
	var new_map_scene: PackedScene = GameSystem.scene_load.loaded_resource
	
	GameSystem.game_wrold.change_map(new_map_scene, target_entry_point)
