class_name PlayerStatsManager extends Node



@export var init_current_hp_value:float=0
@export var init_max_hp_value:float=0

var current_hp:PlayerCurrentHp
var max_hp:PlayerMaxHp


func _ready() -> void:
	for child in get_children():
		if child is PlayerMaxHp:
			max_hp=child as PlayerMaxHp
			max_hp.set_base_value(init_max_hp_value)
			max_hp.value_changed.connect(player_stat_on_changed)
		elif child is PlayerCurrentHp:
			current_hp=child as PlayerCurrentHp
			current_hp.set_value(init_current_hp_value)
			current_hp.value_changed.connect(player_stat_on_changed)

func player_stat_on_changed(stat_name):
	EventBus.player_stat_changed.emit(stat_name)
	
			
