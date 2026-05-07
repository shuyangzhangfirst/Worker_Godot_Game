class_name StatBuff extends Resource

enum BuffType{
	condition,
	duration
}

@export var buff_name:String
@export var buff_type:BuffType
@export var buff_time:float
@export var buff_effect:StatModifier
@export var buff_condition:Array

func _init(name="",type=BuffType.duration,time=0,effect=StatModifier.Add(0),condition=[]) -> void:
	buff_name=name
	buff_type=type
	buff_time=time
	buff_effect=effect
	buff_condition=condition
func Process(delta:float):
	buff_time= max(buff_time-delta,0)
func BuffIsActive():
	if buff_type==BuffType.duration:
		return buff_time>0
	else:
		return CheckConditionIsTrue(buff_condition)
func CheckConditionIsTrue(args:Array)->bool:
	return true

 
