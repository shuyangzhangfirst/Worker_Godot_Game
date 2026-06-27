class_name Bullet extends BulletHitbox

#region 节点引用
@onready var bullet_animated: AnimatedSprite2D = %BulletAnimated
@onready var bullet_collision_shape_2d: CollisionShape2D = %BulletCollisionShape2D
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = %VisibleOnScreenNotifier2D
@onready var clear_timer: Timer = %ClearTimer
#endregion

#region 子弹属性
@export var bullet_name: String = ""		## 子弹名称
@export var bullet_attack: int = 3			## 子弹攻击力
@export var base_bullet_penatration: float = 0.0		## 固定子弹穿透力
@export var percentage_bullet_penatration: float = 0.0	## 子弹百分比穿透
@export var bullet_flight_speed: float = 0.0	## 子弹飞行速度
@export var exit_screen_duration: float = 2.0	## 屏幕外子弹可滞留时间
#endregion

var flight_direction: Vector2	## 飞行方向

func _ready() -> void:
	_init_bullet()
	_connect_signals()

func _physics_process(delta: float) -> void:
	global_position += flight_direction * bullet_flight_speed * delta
	rotation = flight_direction.angle()

func init(muzzle_position: Vector2, shoot_direction: Vector2 = Vector2.RIGHT, _flight_speed: float = 100.0) -> void:
	global_position = muzzle_position
	rotation = shoot_direction.angle()
	flight_direction = shoot_direction
	bullet_flight_speed = _flight_speed
	damage = bullet_attack
	

## 初始化子弹
func _init_bullet() -> void:
	name = bullet_name
	bullet_animated.play("shooting")
	clear_timer.wait_time = exit_screen_duration

#region 子弹清除逻辑
## 子弹进入屏幕内
func _bullet_enter_screen() -> void:
	clear_timer.stop()

## 子弹离开屏幕
func _bullet_exit_screen() -> void:
	clear_timer.start()

## 清除子弹
func _clear_bullet() -> void:
	queue_free()
#endregion

## 连接信号
func _connect_signals() -> void:
	clear_timer.timeout.connect(_clear_bullet)
	visible_on_screen_notifier_2d.screen_entered.connect(_bullet_enter_screen)
	visible_on_screen_notifier_2d.screen_exited.connect(_bullet_exit_screen)
