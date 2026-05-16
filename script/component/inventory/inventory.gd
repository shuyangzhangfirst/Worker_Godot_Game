@tool
extends Control
class_name Inventory

## 节点引用
@onready var item_slot_container: GridContainer = %ItemSlotContainer
## 物品展示
@export var item_display_scene: PackedScene
## 物品容器
@export var item_slots: ItemSlots

func _ready() -> void:
	update_inventory()

## 更新物品栏
func update_inventory() -> void:
	print("物品栏更新")
	_clear_inventory()
	# 将物品加入容器
	_add_inventory()

## 添加物品展示
func _add_inventory() -> void:
	var item_display: ItemDisplay = item_display_scene.instantiate()
	for i in range(item_slots.slots.size()):
		var new_item_display: ItemDisplay = item_display.duplicate()
		new_item_display.name = "ItemDisplay" + "[" + str(i) + "]" 
		new_item_display.item_slot = item_slots.slots[i]
		item_slot_container.add_child(new_item_display)
		new_item_display.update_item_display()

## 清空物品栏
func _clear_inventory() -> void:
	for child in item_slot_container.get_children():
		child.queue_free()
	
