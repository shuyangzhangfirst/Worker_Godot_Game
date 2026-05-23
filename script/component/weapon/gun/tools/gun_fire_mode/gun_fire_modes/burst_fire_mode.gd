extends GunFireMode
class_name GunBurstFireMode

@export var open_fire_cooling_time: float = 0.3	## 开火冷却时间间隔
@export var burst_count: int = 3				## 点射模式发射子弹数
@export var burst_fire_rate: float = 0.03		## 点射每发子弹间隔

var open_fire_cooling_timer: Timer	## 开火冷却计时器
var burst_fire_rate_timer: Timer	## 子弹间隔计时器
var state: BurstState = BurstState.Ready	## 状态
var _burst_shots_fired: int = 0	## 已发射子弹

enum BurstState {
	Ready,
	Bursting
}

func on_trigger_just_pressed() -> void:
	if open_fire_cooling_timer.is_stopped() and state == BurstState.Ready:
		state = BurstState.Bursting
		_fire_next_burst_shot()
	else:
		return

## 下一颗子弹开火
func _fire_next_burst_shot() -> void:
	if _burst_shots_fired < burst_count:
		if burst_fire_rate_timer.is_stopped():
			_burst_shots_fired += 1
			open_fire.emit()
			burst_fire_rate_timer.start()
	else:
		_burst_shots_fired = 0
		open_fire_cooling_timer.start()
		state = BurstState.Ready
		return


func _init_fire_mode() -> void:
	open_fire_cooling_timer = Timer.new()
	add_child(open_fire_cooling_timer)
	open_fire_cooling_timer.name = "连发模式开火冷却计时器"
	open_fire_cooling_timer.wait_time = open_fire_cooling_time
	open_fire_cooling_timer.one_shot = true
	
	burst_fire_rate_timer = Timer.new()
	add_child(burst_fire_rate_timer)
	burst_fire_rate_timer.name = "连发模式子弹间隔计时器"
	burst_fire_rate_timer.wait_time = burst_fire_rate
	burst_fire_rate_timer.one_shot = true
	burst_fire_rate_timer.timeout.connect(_fire_next_burst_shot)
