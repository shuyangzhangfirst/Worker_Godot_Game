extends BaseStat
class_name PlayerCurrentEnergy



var player_stats_manager:PlayerStatsManager


func _ready() -> void:
	if get_parent():
		player_stats_manager=get_parent() as PlayerStatsManager
	
	process_mode=Node.PROCESS_MODE_DISABLED
func add_value(value):
	_base += value
	if player_stats_manager:
		_base=clampf(_base,0,player_stats_manager.max_energy.get_value())
	value_changed.emit(stat_name)
func add_percent(value):
	_base += (_base)*value
	if player_stats_manager:
		_base=clampf(_base,0,player_stats_manager.max_energy.get_value())
	value_changed.emit(stat_name)
func set_percent(value):
	_base = (_base)*value
	if player_stats_manager:
		_base=clampf(_base,0,player_stats_manager.max_energy.get_value())
	value_changed.emit(stat_name)
func set_value(value):
	_base=value
	if player_stats_manager:
		_base=clampf(_base,0,player_stats_manager.max_energy.get_value())
	value_changed.emit(stat_name)
func get_value():
	return _base
