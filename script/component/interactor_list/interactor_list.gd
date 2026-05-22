extends Control
class_name InteractorList

@onready var button_container: VBoxContainer = %ButtonContainer
@onready var interactor_button: Button = %InteractorButton

@export var button_count: int = 5	## 交互器列表按钮数量

var interactors: Array[Interactor] = []	## 交互器列表
var interactor_button_pool: Array[Button]
var focus_index: int = -1	## 交互按钮索引

func _ready() -> void:
	_init_interactor_list()
	_connect_signals()

## 增加交互器
func append_on_interactors(interactor: Interactor) -> void:
	# 防止重复加入交互器
	if interactors.has(interactor):
		push_warning("重复添加同一个交互器: %s", interactor.interactor_name)
		return
	
	interactors.append(interactor)

## 移除交互器
func erase_on_interactors(interactor: Interactor) -> void:
	if interactors.has(interactor):
		interactors.erase(interactor)
		return
	else:
		push_warning("尝试移除一个不在交互列表中的交互器: %s", interactor.interactor_name)

## 初始化交互器列表
func _init_interactor_list() -> void:
	_init_interactor_button_pool()

## 初始化按钮
func _init_interactor_button_pool() -> void:
	interactor_button.visible = false
	
	for i in range(button_count):
		var button: Button = interactor_button.duplicate()
		button.name = "交互按钮[" + str(i) + "]"
		button.text = "默认名称"
		interactor_button_pool.append(button)
		button.pressed.connect(_on_interactor_button_pressed.bind(i))
		button_container.add_child(button)
		
	interactor_button.queue_free()

## 更新交互器列表
func _update_button_container() -> void:
	for i in range(button_count):
		interactor_button_pool[i].visible = false

## 更新交互按钮索引
func _update_focus_index() -> void:
	# 当交互器列表为空时
	if interactors.is_empty():
		focus_index = -1
		return
	
	# 当索引为-1时， 交互器列表不为空时
	if focus_index == -1 and not interactors.is_empty():
		focus_index  = 0
	
	# 当索引大于列表大小时
	if focus_index >= interactors.size():
		focus_index = interactors.size() - 1

## 改变按钮索引
func change_focus_index(param: int) -> void:
	if interactors.size() <= 1:
		focus_index = 0 if not interactors.is_empty() else -1
	else:
		var min_index: int = mini(interactors.size(), interactor_button_pool.size())
		focus_index = wrapi(focus_index + param, 0, min_index)

## 触发交互器交互
func _on_interactor_button_pressed(index: int) -> void:
	if index < 0 or index >= interactors.size():
		push_warning("触发交互索引超出有效范围[当前索引]: %s, [交互器数量]: %s", str(index), str(interactors.size()))
		return
		
	interactors[index].interact()

## 连接信号
func _connect_signals() -> void:
	EventBus.append_on_interactors.connect(append_on_interactors)
	EventBus.erase_on_interactors.connect(erase_on_interactors)
