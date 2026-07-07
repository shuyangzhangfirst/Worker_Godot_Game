extends VirtualStatClass
class_name AdvancedStat





@export var _base:float

var buffs:Array[BuffEffect]
var bonuses:Array[BonusEffect]


var _final_value:float





func add_base_value(value):
	_base+= value
	update_final_value()
func add_base_percent(value):
	_base += (_base)*value
	update_final_value()
func set_base_percent(value):
	_base = (_base)*value
	update_final_value()
	
func set_base_value(value):
	_base=value
	update_final_value()

func get_base_value()->float:
	return _base

	
func add_bonus_value(value:float,effect_type:StatEffect.effecttype,id:int)->int:
	
	var new_bonus= BonusEffect.new()
	new_bonus.source_id=id
	new_bonus.type=effect_type
	new_bonus.value=value
	bonuses.append(new_bonus)
	update_final_value()
	return id
func remove_bonus(source_id:int):
	for i in range(bonuses.size() - 1, -1, -1):
		if bonuses[i].source_id == source_id:
			bonuses.remove_at(i)
	update_final_value()

func add_buff_value(value:float,effect_type:StatEffect,duration:float):
	
	var new_buff = BuffEffect.new()
	new_buff.buff_duration=duration
	new_buff.value=value
	new_buff.type = effect_type
	buffs.append(new_buff)
	update_final_value()

			


func get_value():
	return _final_value



func update_final_value():
	value_changed.emit(stat_name)
	var add_value=0
	var add_percent_effect_value=0
	var set_value=0
	var set_percent_value=1
	var have_set_value=false
	for effect in bonuses:
		if effect.type == StatEffect.effecttype.add_direct:
			add_value+=effect.value
		elif effect.type == StatEffect.effecttype.add_percent:
			add_percent_effect_value+=effect.value
		elif effect.type == StatEffect.effecttype.set_direct:
			set_value = effect.value
			have_set_value=true
		elif effect.type == StatEffect.effecttype.set_percent:
			set_percent_value*=effect.value
	for effect in buffs:
		if effect.type == StatEffect.effecttype.add_direct:
			add_value+=effect.value
		elif effect.type == StatEffect.effecttype.add_percent:
			add_percent_effect_value+=effect.value
		elif effect.type == StatEffect.effecttype.set_direct:
			set_value = effect.value
			have_set_value=true
		elif effect.type == StatEffect.effecttype.set_percent:
			set_percent_value*=effect.value
	
	if have_set_value:
		_final_value=set_value
	else:
		var base=get_base_value()
		base +=add_value
		base += add_percent_effect_value*base
		base*=set_percent_value
		_final_value=base
	
func _physics_process(delta: float) -> void:
	if buffs.size() ==0:
		return 
	var should_update=false
	for i in range(buffs.size() - 1, -1, -1):
		buffs[i].buff_duration-=delta
		if buffs[i].buff_duration<=0:
			buffs.remove_at(i)
			should_update=true
	if should_update:
		update_final_value()
