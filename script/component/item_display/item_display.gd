extends Control
class_name  ItemDisplay

## 节点引用
@onready var backgorund: TextureRect = %Backgorund
@onready var item_icon: TextureRect = %ItemIcon
@onready var item_count_label: Label = %ItemCountLabel

## 物品资源 
@export var item_slot: ItemSlot

## 物品最大堆叠数
@export var max_stack: int = 1:
	set(value):
		max_stack = 1 if value < 1 else value
## 物品数量
@export	var item_count: int = 0:
	set(value):
		if value <= 0:
			item_slot = null
			item_count = 0
		elif value > max_stack:
			item_count = max_stack
		else:
			item_count = value

## 更新物品槽位
func update_item_display() -> void:
	if item_slot:
		item_icon.texture = item_slot.item.item_icon
	else:
		item_icon.texture = null
		item_count = 0
		
	_update_item_count_label()

## 更新物品数量标签
func _update_item_count_label() -> void:
	if item_slot.item_count < 1:
		item_count_label.visible = false
	else:
		item_count_label.text = str(item_slot.item_count)
		item_count_label.visible = true
		
	
		
		
