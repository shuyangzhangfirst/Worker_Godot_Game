extends Node
class_name BaseStat

@export var _base:float





func add_value(value):
	_base += value
func add_percent(value):
	_base += (_base)*value
func set_percent(value):
	_base = (_base)*value
	
func set_value(value):
	_base=value

func get_value():
	return _base
