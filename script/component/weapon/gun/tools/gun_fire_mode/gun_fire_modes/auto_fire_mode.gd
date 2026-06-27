extends GunFireMode
class_name GunAutoFireMode

@export var trigger_cooldown_time: float = 0.1		## 扳机冷却时间
@export var auto_fire_rate: float = 0.1		## 全自动子弹间隔

var trigger_cooldown_timer: Timer	## 扳机冷却计时器
var auto_fire_rate_timer: Timer	## 子弹间隔计时器

func _physics_process(_delta: float) -> void:
	if auto_fire_rate_timer.is_stopped():
		shoot_bullet.emit()
		auto_fire_rate_timer.start()

func on_trigger_just_pressed() -> void:
	set_physics_process(true)
	
	
func on_trigger_just_release() -> void:
	set_physics_process(false)


func _init_fire_mode() -> void:
	set_physics_process(false)
	
	trigger_cooldown_timer = Timer.new()
	add_child(trigger_cooldown_timer)
	trigger_cooldown_timer.name = "扳机冷却计时器"
	trigger_cooldown_timer.wait_time = trigger_cooldown_time
	trigger_cooldown_timer.one_shot = true
	
	auto_fire_rate_timer = Timer.new()
	add_child(auto_fire_rate_timer)
	auto_fire_rate_timer.name = "连发模式子弹间隔计时器"
	auto_fire_rate_timer.wait_time = auto_fire_rate
	auto_fire_rate_timer.one_shot = true
