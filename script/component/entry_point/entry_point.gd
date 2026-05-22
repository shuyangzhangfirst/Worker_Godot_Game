@tool
class_name EntryPoint
extends Marker2D


@onready var label: Label = %Label
@onready var debug_tool: Node2D = %DebugTool
@onready var animation_player: AnimationPlayer = %AnimationPlayer

@export var entry_point_name: String = ""	## 进入点名称
## 导出枚举方向属性
@export var player_direction: PlayerDirection = PlayerDirection.DOWN	## 玩家从进入点进入地图时的方向

enum PlayerDirection {
	RIGHT,
	LEFT,
	UP,
	DOWN
}

func _ready() -> void:
	_naming()
	add_to_group("entry_points")
	
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		label.text = entry_point_name + "[" + get_directtion_string(player_direction) + "]"
		if animation_player.is_playing():
			return
		else:
			animation_player.play("float")
	else:
		set_process(false)
		visible = false
		debug_tool.queue_free()
	


# 获取实际方向向量
func get_direction() -> Vector2:
	match player_direction:
		PlayerDirection.RIGHT:
			return Vector2.RIGHT
		PlayerDirection.LEFT:
			return Vector2.LEFT
		PlayerDirection.UP:
			return Vector2.UP
		PlayerDirection.DOWN:
			return Vector2.DOWN
		_:
			return Vector2.DOWN  # 默认值

func get_directtion_string(direction: PlayerDirection) -> String:
	match direction:
		PlayerDirection.RIGHT:
			return "右"
		PlayerDirection.LEFT:
			return "左"
		PlayerDirection.UP:
			return "上"
		PlayerDirection.DOWN:
			return "下"
		_:
			return "未知方向"

func _naming() -> void:
	if entry_point_name == "":
		entry_point_name = get_name()
