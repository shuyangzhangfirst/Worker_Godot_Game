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
		elif child is PlayerCurrentHp:
			current_hp=child as PlayerCurrentHp
			current_hp.set_value(init_current_hp_value)

			
