extends Node
class_name VirtualStatClass

signal value_changed(s_name:String)
@export var stat_name:String
@export var _base:float
func _ready() -> void:
	process_mode=Node.PROCESS_MODE_DISABLED
	
func get_value():
	pass
