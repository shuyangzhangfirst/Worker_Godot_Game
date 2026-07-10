extends VirtualStatClass
class_name BaseStat







func add_value(value):
	_base += value
	value_changed.emit(stat_name)
func add_percent(value):
	_base += (_base)*value
	value_changed.emit(stat_name)
func set_percent(value):
	_base = (_base)*value
	value_changed.emit(stat_name)
func set_value(value):
	_base=value
	value_changed.emit(stat_name)
func get_value():
	return _base
