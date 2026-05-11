class_name PlayerMaxHealth extends Stat

@export var strength_coefficient=5

func Init():
	self.stat_type=StatType.maxhealth

func ComputeStat():
	if !rely_on_stats.has(StatType.strength) :
		return base_value
	return rely_on_stats[StatType.strength].GetValue()*strength_coefficient+GetBaseValue()
