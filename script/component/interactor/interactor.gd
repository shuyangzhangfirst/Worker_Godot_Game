@tool
extends Area2D
class_name Interactor

@export var interactor_name: String = ""	## 交互器名称
@export var is_active: bool = true			## 是否启用

func _init() -> void:
	collision_mask = 2
	collision_layer = 4
	set_collision_mask_value(2, true)
	
func _ready() -> void:
	_connect_signals()

## 节点退出场景树时，将自身移除交互列表
func _exit_tree() -> void:
	pass

## 交互函数
func interact() -> void:
	print("[交互] %s" %interactor_name)

## 玩家进入交互器
func _on_body_entered(body: Node2D) -> void:
	if not is_active or not body is Player:
		return
	print("[进入交互] %s" %interactor_name)
	
	EventBus.append_on_interactors.emit(self)

## 玩家离开交互器
func _on_body_exited(body: Node2D) -> void:
	if not is_active or not body is Player:
		return
	print("[离开交互] %s" %interactor_name)
	
	EventBus.erase_on_interactors.emit(self)
	
## 连接信号
func _connect_signals() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
