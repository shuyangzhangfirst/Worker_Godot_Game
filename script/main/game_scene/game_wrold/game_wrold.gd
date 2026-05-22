extends Node2D
class_name GameWrold

@onready var map: Node = %Map
@onready var entity: Node = %Entity
@onready var prop: Node = %Prop

func _ready() -> void:
	GameSystem.game_wrold = self

func change_map(new_map_scene: PackedScene, entry_point_name: String) -> void:
	
	_clear_map()
	var new_map: BaseMap = new_map_scene.instantiate()
	map.add_child(new_map)
	
	var entry_point: EntryPoint = get_target_entry_point(entry_point_name)
	_move_player_to_entry_point(entry_point)
	print("切换完成")
	
## 将玩家移动到入口点并转向入口方向
func _move_player_to_entry_point(entry_point: EntryPoint) -> void:
	var player: Player
	if GameSystem.data.current_player:
		player = GameSystem.data.current_player
	else:
		push_error("传送时未找到玩家节点")
		return
	
	player.global_position = entry_point.global_position
	player.change_ani_dir(entry_point.get_direction())
		
	


func _clear_map() -> void:
	for child in map.get_children():
		child.queue_free()

func get_target_entry_point(entry_point_name: String) -> EntryPoint:
	var entry_points: Array[Node] = get_tree().get_nodes_in_group("entry_points")
	for entry_point in entry_points:
		if entry_point.entry_point_name == entry_point_name:
			return entry_point
	
	push_error("未找到入口点: %s", entry_point_name)
	return null
	
	
