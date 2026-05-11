@tool
extends Resource
class_name ItemSlot

@export var item: Item
@export var item_count: int = 1:
	set(value):
		if value > item.max_stack:
			item_count = item.max_stack
		else:
			item_count = value
