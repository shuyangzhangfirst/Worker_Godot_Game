extends GunFireMode
class_name GunSingleFireMode

@export var open_fire_cooldown_time: float = 0.2	## 开火冷却时间

var open_fire_cooling_timer: Timer	## 开火冷却计时器

func on_trigger_just_pressed() -> void:
	if open_fire_cooling_timer.is_stopped():
		shoot_bullet.emit()
		open_fire_cooling_timer.start()
	else:
		return
	
func _init_fire_mode() -> void:
	open_fire_cooling_timer = Timer.new()
	add_child(open_fire_cooling_timer)
	open_fire_cooling_timer.name = "开火冷却计时器"
	open_fire_cooling_timer.wait_time = open_fire_cooldown_time
	open_fire_cooling_timer.one_shot = true
	
	
