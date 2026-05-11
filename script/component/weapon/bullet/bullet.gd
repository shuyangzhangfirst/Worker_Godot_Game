class_name Bullet extends Hitbox

#region 节点引用
@onready var bullet_animated: AnimatedSprite2D = %BulletAnimated
@onready var bullet_collision_shape_2d: CollisionShape2D = %BulletCollisionShape2D
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = %VisibleOnScreenNotifier2D
@onready var clear_timer: Timer = %ClearTimer

#endregion
@export var bullet_name: String = ""
@export var bullet_flight_speed: float = 300.0	## 子弹飞行速度
@export var exit_screen_duration: float = 2.0	## 屏幕外子弹可滞留时间
@export var target: Node2D



var _shoot_direction: Vector2	## 射击方向

func _ready() -> void:
	_init_bullet()
	_connect_signals()
	self.damage=1
	
	

func _process(delta: float) -> void:
	global_position += _shoot_direction * bullet_flight_speed * delta
	rotation = _shoot_direction.angle()

## 子弹击中目标 
## 对于攻击来说，我们需要交给受击框来处理，因为受击的那一方才是需要进行减血
## 或者受伤操作的人
#func hitting_target(hitted_target: Node2D) -> void:
	#if hitted_target is Character:
		#pass

func init(muzzle_position: Vector2, shoot_direction: Vector2 = Vector2.RIGHT) -> void:
	global_position = muzzle_position
	_shoot_direction = shoot_direction

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
	
	#body_entered.connect(hitting_target)
	
	
	visible_on_screen_notifier_2d.screen_entered.connect(_bullet_enter_screen)
	visible_on_screen_notifier_2d.screen_exited.connect(_bullet_exit_screen)
