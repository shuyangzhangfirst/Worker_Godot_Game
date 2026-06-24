extends PanelContainer
class_name InventoryInterface



@onready var slot_container: GridContainer = %SlotContainer

@export var item_slot_scene: PackedScene
@export var inventory: Inventory

func _ready() -> void:
	update_inventory_interface()
	
## 更新物品栏接口
func on_item_picked_up(item:Item,quantity:int):
	pass
	
func update_inventory_interface() -> void:
	_clear_inventory_interface()

	if inventory:
		for item_slot_data in inventory.item_slot_datas:
			var new_item_slot: ItemSlot = item_slot_scene.instantiate()
			new_item_slot.item_slot_data = item_slot_data
			slot_container.add_child(new_item_slot)
			new_item_slot.update_item_slot()
	else:
		push_error("物品栏接口没有配置数据资源")

## 清理物品栏接口
func _clear_inventory_interface() -> void:
	for child in slot_container.get_children():
		child.queue_free()
