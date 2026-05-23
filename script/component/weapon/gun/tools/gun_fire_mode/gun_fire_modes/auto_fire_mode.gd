extends GunFireMode
class_name GunAutoFireMode

@export var open_fire_cooling_time: float = 0.3	## 开火冷却时间间隔
@export var auto_fire_rate: float = 0.05		## 全自动子弹间隔

var open_fire_cooling_timer: Timer	## 开火冷却计时器
var auto_fire_rate_timer: Timer	## 子弹间隔计时器

func _physics_process(_delta: float) -> void:
	if auto_fire_rate_timer.is_stopped():
		open_fire.emit()
		auto_fire_rate_timer.start()

func on_trigger_just_pressed() -> void:
	set_physics_process(true)
	
	
func on_trigger_just_release() -> void:
	set_physics_process(false)


func _init_fire_mode() -> void:
	set_physics_process(false)
	open_fire_cooling_timer = Timer.new()
	add_child(open_fire_cooling_timer)
	open_fire_cooling_timer.name = "连发模式开火冷却计时器"
	open_fire_cooling_timer.wait_time = open_fire_cooling_time
	open_fire_cooling_timer.one_shot = true
	
	auto_fire_rate_timer = Timer.new()
	add_child(auto_fire_rate_timer)
	auto_fire_rate_timer.name = "连发模式子弹间隔计时器"
	auto_fire_rate_timer.wait_time = auto_fire_rate
	auto_fire_rate_timer.one_shot = true
