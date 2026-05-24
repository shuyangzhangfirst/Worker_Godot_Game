extends GunFireMode
class_name GunSingleFireMode

@export var open_fire_cooling_time: float = 0.3

var open_fire_cooling_timer: Timer	## 开火冷却计时器

func on_trigger_just_pressed() -> void:
	if open_fire_cooling_timer.is_stopped():
		open_fire_cooling_timer.start()
		open_fire.emit()
	else:
		return
	
func _init_fire_mode() -> void:
	open_fire_cooling_timer = Timer.new()
	add_child(open_fire_cooling_timer)
	open_fire_cooling_timer.name = "单发模式开火冷却计时器"
	open_fire_cooling_timer.wait_time = open_fire_cooling_time
	open_fire_cooling_timer.one_shot = true
	
