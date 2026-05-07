class_name Stat extends Resource
enum StatType{
	health,
	maxhealth,
	stamina,
	maxstamina,
	sanity,
	maxsanity,
	drink,
	maxdrink,
	hungry,
	maxhungry,
	sleep,
	maxsleep,
	enjoyment,
	strength,
	intelligent,
	charm,
	lucky
}
signal StatChanged(newstat:Stat)
@export var stat_type : StatType
@export var base_value:float=0
var computed_value:float=0
var result_value:float =0
var buffs:Dictionary[String,StatBuff]={}
@export var rely_on_stats:Dictionary[StatType,Stat]={}

func SetBaseValue(value):
	base_value=value
	
	UpdateValue()
	
func GetValue():
	return result_value

func ChangeBaseValue(modifier:StatModifier):
	base_value=modifier.Operatoe(base_value)
	UpdateValue()

func UpdateValue():
	var original_value=GetValue()
	computed_value=ComputeStat()
	result_value=ApplyBuffs()
	if result_value != original_value:
		StatChanged.emit(result_value)

func ApplyBuffs():
	var result=computed_value
	for buff in buffs.values():
		result=buff.buff_effect.Operatoe(result)
	return result
		
	

func ComputeStat():
	return base_value

func AddBuff(buff:StatBuff):
	if buff.buff_name in buffs:
		if buffs[buff.buff_name].buff_type==StatBuff.BuffType.duration:
			buffs[buff.buff_name].buff_time = buff.buff_time
	
	buffs[buff.buff_name]=buff
	UpdateValue()

func RemoveBuff(buff_name:String):
	buffs.erase(buff_name)
	UpdateValue()
	
	
	
	







	
	
