extends Marker2D
class_name Crosshair
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var gun: Gun = $".."

var gun_muzzle_distance: float = 1.0	## 枪支到枪口距离
var gun_mouse_distance: float	## 枪支到准星距离

func _ready() -> void:
	animated_sprite_2d.play("crosshair")
	_init_crosshair.call_deferred()
	
func _process(_delta: float) -> void:
	_update_crosshair_position()

func _init_crosshair() -> void:
	gun_muzzle_distance = gun.get_gun_muzzle_distance()

## 更新准星位置
func _update_crosshair_position() -> void:
	var target_position: Vector2
	var mouse_position: Vector2 = get_global_mouse_position()
	
	# 计算鼠标到枪的距离和方向
	var to_mouse: Vector2 = mouse_position - gun.global_position
	gun_mouse_distance = to_mouse.length()
	var mouse_direction: Vector2 = to_mouse.normalized() if gun_mouse_distance > 0 else Vector2.RIGHT
	var muzzle_direction = gun.global_position.direction_to(gun.muzzle.global_position)
	
	if gun_mouse_distance <= gun_muzzle_distance:
		# 在最小距离圆上，完全跟随鼠标方向
		target_position = gun.global_position + mouse_direction * gun_muzzle_distance
	else:
		target_position = mouse_position
	
	global_position = target_position
