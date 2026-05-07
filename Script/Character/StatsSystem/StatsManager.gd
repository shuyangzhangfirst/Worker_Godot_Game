class_name StatsManager extends Node

@export var stats:Array[Stat]

func _physics_process(delta: float) -> void:
	
	for stat in stats:
		var removed_buff=[]
		for buff in stat.buffs.values():
			buff.Process()
			if !buff.BuffIsActive():
				removed_buff.append(buff.buff_name)
		for buff_namee in removed_buff:
			stat.RemoveBuff(buff_namee)


			
			
