extends Control
class_name PlayerHUD

@onready var health_progress_bar: TextureProgressBar = %healthProgressBar
@onready var realhealth_progress_bar: TextureProgressBar = %RealhealthProgressBar
@onready var max_health_label: Label = %MaxHealthLabel
@onready var show_health_label: Label = %ShowHealthLabel

@onready var panel_container: PanelContainer = $PanelContainer
@onready var energy_progress_bar: TextureProgressBar = %EnergyProgressBar
@onready var real_energy_progress_bar: TextureProgressBar = %RealEnergyProgressBar
@onready var show_energy_label: Label = %ShowEnergyLabel
@onready var max_energy_label: Label = %MaxEnergyLabel


## 跟踪玩家目标
@export var player: Player

func _ready() -> void:
	_init_player_hud()
	set_process(false)
	EventBus.player_stat_changed.connect(_update_player_hud)
	
func _process(_delta: float) -> void:
	_update_transition()
	pass
	
## 初始化HUD
func _init_player_hud() -> void:
	if not player:
		player = GameSystem.data.current_player
		_init_player_hud()
		return
		
	## 生命值
	max_health_label.text = format_float_to_str(player.player_stats.max_hp.get_value())
	show_health_label.text = format_float_to_str(player.player_stats.current_hp.get_value())
	health_progress_bar.max_value = player.player_stats.max_hp.get_value()
	health_progress_bar.value = player.player_stats.current_hp.get_value()
	realhealth_progress_bar.value = player.player_stats.current_hp.get_value()
	realhealth_progress_bar.max_value = player.player_stats.max_hp.get_value()
	
	## 能量值
	max_energy_label.text = format_float_to_str(player.player_stats.max_energy.get_value())
	show_health_label.text = format_float_to_str(player.player_stats.current_hp.get_value())
	energy_progress_bar.max_value = player.player_stats.max_energy.get_value()
	energy_progress_bar.value = player.player_stats.current_energy.get_value()
	real_energy_progress_bar.max_value = player.player_stats.max_energy.get_value()
	real_energy_progress_bar.value = player.player_stats.current_energy.get_value()

	

func _update_player_hud(updated_stat_name: String) -> void:
	# 最大生命值
	
	if updated_stat_name == player.player_stats.max_hp.stat_name:
		realhealth_progress_bar.max_value = player.player_stats.max_hp.get_value()
		max_health_label.text = format_float_to_str(player.player_stats.max_hp.get_value())
		max_health_label.text = format_float_to_str(player.player_stats.max_hp.get_value())
		set_process(true)
	# 生命值
	elif updated_stat_name == player.player_stats.current_hp.stat_name:
		realhealth_progress_bar.value = player.player_stats.current_hp.get_value()
		show_health_label.text = format_float_to_str(player.player_stats.current_hp.get_value())
		set_process(true)
	# 最大能量值
	elif updated_stat_name == player.player_stats.max_energy.stat_name:
		real_energy_progress_bar.max_value = player.player_stats.max_energy.get_value()
		max_energy_label.text = format_float_to_str(player.player_stats.max_energy.get_value())
		show_health_label.text = format_float_to_str(player.player_stats.current_hp.get_value())
		set_process(true)
		
	elif updated_stat_name == player.player_stats.current_energy.stat_name:
		real_energy_progress_bar.value = player.player_stats.current_energy.get_value()
		show_energy_label.text = format_float_to_str(player.player_stats.max_energy.get_value())
		show_energy_label.text = format_float_to_str(player.player_stats.current_energy.get_value())
		set_process(true)
		

func _update_transition() -> void:
	var is_updated: bool = true
	
	## 生命值
	if realhealth_progress_bar.value >= health_progress_bar.value:
		health_progress_bar.value = realhealth_progress_bar.value
	else:
		health_progress_bar.value -= 0.1
		is_updated = false
	
	## 能量值
	if real_energy_progress_bar.value >= energy_progress_bar.value:
		energy_progress_bar.value = real_energy_progress_bar.value
	else:
		energy_progress_bar.value -= 0.1
		is_updated = false
		
	if is_updated:
		print("更新完成")
		set_process(false)
		
func format_float_to_str(value: float) -> String:
	return str(snapped(value, 0.1))
