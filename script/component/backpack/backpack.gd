@tool
extends Control
class_name Backpack

@onready var inventory_interface: InventoryInterface = %InventoryInterface

func _ready() -> void:
	_init_inventory_interface()
	
func _shortcut_input(event: InputEvent) -> void:
	if event.is_action_pressed("backpack"):
		if visible:
			hide_backpack()
		else:
			show_backpack()

func _update_backpack() -> void:
	inventory_interface.update_inventory_interface()

func _init_inventory_interface() -> void:
	hide_backpack()
	inventory_interface.inventory = GameSystem.data.player_inventory
	inventory_interface.update_inventory_interface()

func show_backpack() -> void:
	_update_backpack()
	show()

func hide_backpack() -> void:
	hide()
	
