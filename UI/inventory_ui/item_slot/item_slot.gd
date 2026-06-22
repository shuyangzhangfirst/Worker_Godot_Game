extends Control
class_name ItemSlot

@onready var item_icon: TextureRect = %ItemIcon
@onready var item_count_label: Label = %ItemCountLabel

var item_slot_data: ItemSlotData

func _ready() -> void:
	update_item_slot()

## 更新物品槽
func update_item_slot() -> void:
	if item_slot_data:
		item_icon.texture = item_slot_data.slot_item.item_icon
		item_count_label.text = str(item_slot_data.item_count)
		if item_slot_data.item_count <= 1:
			item_count_label.visible = false
		else:
			item_count_label.visible = true
	else:
		item_icon.texture = null
		item_count_label.text = "0"
		item_count_label.visible = false
