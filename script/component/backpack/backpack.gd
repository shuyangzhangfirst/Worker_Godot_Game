@tool
extends Control
class_name Backpack

@onready var inventory: Inventory = %Inventory

@export var item_slots: ItemSlots:
	set(value):
		item_slots = value
		if inventory:
			inventory.item_slots = item_slots

## 添加物品进入背包物品栏
func item_slots_add_to_inventory(slots: ItemSlots) -> void:
	var inventory_slots: ItemSlots = inventory.item_slots
	
	# 尝试合并到已有堆叠
	for new_slot in slots.slots:
		var remaining = new_slot.item_count	# 剩余数量
		
		## 合并背包内已有物品
		for slot in inventory_slots.slots:
			if slot.item == new_slot.item:
				if slot.item_count >= slot.item.max_stack:
					continue
				var count: int = slot.item_count + remaining
				if count > slot.item.max_stack:
					slot.item_count = slot.item.max_stack
					remaining = count - slot.item.max_stack
		
		## 多余的堆叠
		if remaining > 0:
			new_slot.item_count = remaining
			inventory_slots.slots.append(new_slot)
		

func _ready() -> void:
	_connect_signals()
	
func _connect_signals() -> void:
	pass
