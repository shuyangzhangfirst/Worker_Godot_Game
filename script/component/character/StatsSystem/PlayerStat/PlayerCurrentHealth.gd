class_name PlayerCurrentHealth extends Stat

func Init():
	self.stat_type=StatType.health
	

func UpdateValue():
	var original_value=GetValue()
	computed_value=ComputeStat()
	result_value=ApplyBuffs()
	if rely_on_stats.has(StatType.maxhealth):
		result_value=clamp(result_value,0,rely_on_stats)
	if result_value != original_value:
		StatChanged.emit(result_value)
