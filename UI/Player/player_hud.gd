extends Control
class_name PlayerHUD

@onready var health_progress_bar: TextureProgressBar = %healthProgressBar
@onready var realhealth_progress_bar: TextureProgressBar = %RealhealthProgressBar
@onready var max_health_label: Label = %MaxHealthLabel
@onready var show_health_label: Label = %ShowHealthLabel

## 跟踪玩家目标
@export var player: Player

func _ready() -> void:
	_init_player_hud()
	set_process(false)
	
func _process(_delta: float) -> void:
	_update_transition()

## 初始化HUD
func _init_player_hud() -> void:
	if not player:
		player = GameSystem.data.current_player
		_init_player_hud()
		return
		
	## 生命值
	max_health_label.text = str(player.player_stats.max_hp.get_value())
	show_health_label.text = str(player.player_stats.current_hp.get_value())
	health_progress_bar.max_value = player.player_stats.max_hp.get_value()
	health_progress_bar.value = player.player_stats.current_hp.get_value()
	realhealth_progress_bar.value = player.player_stats.current_hp.get_value()
	realhealth_progress_bar.max_value = player.player_stats.max_hp.get_value()
	
func _update_player_hud(updated_stat_name: String) -> void:
	# 最大生命值
	if updated_stat_name == player.player_stats.max_hp.stat_name:
		realhealth_progress_bar.max_value = player.player_stats.max_hp.get_value()
		max_health_label.text = str(player.player_stats.max_hp.get_value())
		max_health_label.text = str(player.player_stats.max_hp.get_value())
		set_process(true)
	# 生命值
	if updated_stat_name == player.player_stats.current_hp.get_value():
		realhealth_progress_bar.value = player.player_stats.current_hp.get_value()
		show_health_label.text = str(player.player_stats.current_hp.get_value())
		set_process(true)
		
func _update_transition() -> void:
	## 生命值
	if realhealth_progress_bar.value >= health_progress_bar.value:
		health_progress_bar.value = realhealth_progress_bar.value
		set_process(false)
	else:
		health_progress_bar.value -= health_progress_bar.value * 0.05
		
		
