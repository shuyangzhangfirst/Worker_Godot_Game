extends BaseStat
class_name PlayerCurrentHp


var player_stats_manager:PlayerStatsManager


func _ready() -> void:
	if get_parent():
		player_stats_manager=get_parent() as PlayerStatsManager


func add_value(value):
	_base += value
	if player_stats_manager:
		_base=clampf(_base,0,player_stats_manager.max_hp.get_value())

func add_percent(value):
	_base += (_base)*value
	if player_stats_manager:
		_base=clampf(_base,0,player_stats_manager.max_hp.get_value())

func set_percent(value):
	_base = (_base)*value
	if player_stats_manager:
		_base=clampf(_base,0,player_stats_manager.max_hp.get_value())

func set_value(value):
	_base=value
	if player_stats_manager:
		_base=clampf(_base,0,player_stats_manager.max_hp.get_value())

func get_value():
	return _base
