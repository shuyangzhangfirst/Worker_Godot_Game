class_name PlayerStatsManager extends Node







var current_hp:PlayerCurrentHp
var max_hp:PlayerMaxHp
var walk_speed:PlayerWalkSpeed
var run_speed:PlayerRunSpeed
var max_energy:PlayerMaxEnergy
var current_energy:PlayerCurrentEnergy
var energy_generate_rate:PlayerEnergyGenerateRate #能量每秒回复多少百分比
var energy_generate_interval:PlayerEnergyGenerateInterval #能量回复间隔，多少秒后可以自动回复
var energy_recover_timer:float=0
func _ready() -> void:
	for child in get_children():
		if child is PlayerMaxHp:
			max_hp=child as PlayerMaxHp
			max_hp.value_changed.connect(player_stat_on_changed)
		elif child is PlayerCurrentHp:
			current_hp=child as PlayerCurrentHp
			current_hp.value_changed.connect(player_stat_on_changed)
		elif child is PlayerRunSpeed:
			run_speed=child as PlayerRunSpeed
			run_speed.value_changed.connect(player_stat_on_changed)
		elif child is PlayerWalkSpeed:
			walk_speed=child as PlayerWalkSpeed
			walk_speed.value_changed.connect(player_stat_on_changed)
		elif child is PlayerMaxEnergy:
			max_energy=child
			max_energy.value_changed.connect(player_stat_on_changed)
		elif  child is PlayerCurrentEnergy:
			current_energy=child
			current_energy.value_changed.connect(player_stat_on_changed)
		elif child is PlayerEnergyGenerateRate:
			energy_generate_rate=child
			energy_generate_rate.value_changed.connect(player_stat_on_changed)
		elif child is PlayerEnergyGenerateInterval:
			energy_generate_interval=child
			energy_generate_interval.value_changed.connect(player_stat_on_changed)
func player_stat_on_changed(stat_name):
	EventBus.player_stat_changed.emit(stat_name)
func _physics_process(delta: float) -> void:
	if energy_recover_timer<=0:
		player_energy_regenerate(energy_generate_rate.get_value()*max_energy.get_value())
		energy_recover_timer = 1
	else:
		energy_recover_timer-=delta
func player_just_cost_energy():
	energy_recover_timer=energy_generate_interval.get_value()
func player_energy_regenerate(value):
	current_energy.add_value(value)
			
