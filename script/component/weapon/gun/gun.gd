class_name Gun extends Weapon

## 节点引用
#region 新建代码区域
@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var barrel_chamber: Marker2D = %BarrelChamber
@onready var muzzle: Marker2D = %Muzzle
@onready var gun_wire: Node2D = %GunWire
@onready var cooldown_timer: Timer = %CooldownTimer
@onready var burst_timer: Timer = %BurstTimer
@onready var auto_timer: Timer = %AutoTimer

#endregion

#region 枪械属性

@export_group("枪械属性")
@export var bullet_scene: PackedScene						## 子弹场景
@export var rotation_speed: float = 10.0					## 枪支转动速度
@export var spread_angle: float = 0.01						## 枪口扩散
@export var magazine_size: int = 12							## 弹匣容量
@export var gun_fire_mode:Array[GunFireMode]

@export_group("开火模式属性")
@export_subgroup("单发模式")
@export var single_cooldown_time: float = 0.2	## 单发模式扳机间隔
@export_subgroup("点射模式")
@export var burst_count: int = 3				## 点射模式发射子弹数
@export var burst_fire_rate: float = 0.03			## 点射每发子弹间隔
@export var burst_cooldown_time: float = 0.2	## 点射模式扳机间隔
@export_subgroup("全自动模式")
@export var auto_fire_rate: float = 0.1			## 全自动每发子弹间隔
@export var auto_cooldown_time: float = 0.4		## 全自动模式扳机间隔
@export_subgroup("充能模式")
@export var gun_charge_time: float = 1.0		## 充能模式充能时间
#endregion

var _burst_shots_fired: int = 0  ## 当前点射已发射数
var _is_bursting: bool = false  ## 是否正在点射中

var gun_fire_mode_index: int = 0		## 开火模式索引
var _safe_rotation: float = 0.15		## 安全转向角度
var gun_direction: Vector2				## 枪支指向方向

var is_trigger: bool = false:			## 扳机状态
	set(value):
		is_trigger = value
		if not value:
			#print("扳机松开")
			if cooldown_timer.is_stopped():
				is_able_fire = false
				cooldown_timer.start()
		else:
			pass
			#print("扳机按下")

var is_able_fire: bool = true:			## 可以开火
	set(value):
		is_able_fire = value

## 当前开火模式
var _current_fire_mode: GunFireMode = GunFireMode.Single:
	set(value):
		_current_fire_mode = value
		if _current_fire_mode == GunFireMode.Auto or _current_fire_mode == GunFireMode.Charge:
			cooldown_timer.wait_time = auto_cooldown_time
			return
		if _current_fire_mode == GunFireMode.Single:
			cooldown_timer.wait_time = single_cooldown_time
			return
		if _current_fire_mode == GunFireMode.Burst:
			cooldown_timer.wait_time = burst_cooldown_time
			return
			

enum GunFireMode {		## 枪械开火模式
	Single = 0,		## 单发
	Burst = 1,		## 点射
	Auto = 2,		## 全自动
	Charge = 3,    ## 蓄力
}

func _ready() -> void:
	_init_gun()
	_connect_signals()

func _shortcut_input(event: InputEvent) -> void:
	if event.is_action_pressed("change_fire_mode"):
		turn_fire_mode()

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		is_trigger = true
	elif Input.is_action_just_released("attack"):
		is_trigger = false
		
	if is_trigger:
		if is_able_fire:
			_open_fire()


func _process(delta: float) -> void:
	_update_gun_facing(delta)

## 初始化枪支
func _init_gun() -> void:
	_current_fire_mode = gun_fire_mode[0]
	cooldown_timer.one_shot = true
	
	# 点射计时器
	burst_timer.one_shot = true
	burst_timer.wait_time = burst_fire_rate
	
	auto_timer.one_shot = true
	auto_timer.wait_time = auto_fire_rate
	
## 开火
func _open_fire() -> void:
	if _current_fire_mode == GunFireMode.Single:
		_open_fire_single()
	if _current_fire_mode == GunFireMode.Burst:
		_open_fire_burst()
	if _current_fire_mode == GunFireMode.Auto:
		_open_fire_auto()
	if _current_fire_mode == GunFireMode.Charge:
		_open_fire_charge()
	
## 枪支射击
func _shoot_bullet() -> void:
	var new_bullet: Bullet = bullet_scene.instantiate()
	new_bullet.init(muzzle.global_position, _create_bullet_direction())
	get_tree().current_scene.add_child(new_bullet)

#region 开火模式
## 单发开火
func _open_fire_single() -> void:
	is_able_fire = false
	_shoot_bullet()

## 点射开火
func _open_fire_burst() -> void:
	if _is_bursting:
		return
	
	_is_bursting = true
	_burst_shots_fired = 0
	is_able_fire = false
	_fire_next_burst_shot()

## 发射点射的下一发
func _fire_next_burst_shot() -> void:
	if _burst_shots_fired >= burst_count:
		_is_bursting = false
		_burst_shots_fired = 0
		return
	
	# 发射子弹
	_shoot_bullet()
	_burst_shots_fired += 1
	# 如果还有子弹要发射，启动间隔计时器
	if _burst_shots_fired <= burst_count and _is_bursting:
		burst_timer.start()
		
## 点射计时器到时
func _on_burst_timer_timeout() -> void:
	if _is_bursting:
		_fire_next_burst_shot()
		
## 全自动开火
func _open_fire_auto() -> void:
	if is_able_fire and is_trigger:
		is_able_fire = false
		_shoot_bullet()
		auto_timer.start()
	
## 充能开火
func _open_fire_charge() -> void:
	pass
#endregion
	
## 更新枪支朝向
func _update_gun_facing(delta: float) -> void:

	var target_direction: Vector2 = barrel_chamber.global_position.direction_to(get_global_mouse_position())
	var target_rotation: float = target_direction.angle()
	
	rotation = lerp_angle(rotation, target_rotation, delta * rotation_speed)
	gun_direction = Vector2.from_angle(rotation)
	if gun_direction.x >= _safe_rotation:
		scale.y = abs(scale.y)
	elif gun_direction.x <= -_safe_rotation:
		scale.y = -abs(scale.y)

## 切换开火模式
func turn_fire_mode() -> void:
	gun_fire_mode_index = wrapi(gun_fire_mode_index + 1 ,0 , gun_fire_mode.size())
	_current_fire_mode = gun_fire_mode[gun_fire_mode_index]
	print("当前开火模式: " + _get_gun_fire_mode_name(_current_fire_mode))

## 生成子弹方向 = 枪械方向 +- 随机枪口扩散
func _create_bullet_direction() -> Vector2:
	var gun_rotation: float = gun_direction.angle()
	gun_rotation += randf_range(-abs(spread_angle), abs(spread_angle))
	return Vector2.from_angle(gun_rotation)

## 开火冷却完成
func _fire_cooltime_over() -> void:
	#print("开火冷却完成")
	is_able_fire = true

## 返回枪械开火模式字符串
func _get_gun_fire_mode_name(index: int) -> String:
	if index == 0:
		return "单发模式"
	if index == 1:
		return "连发模式"
	if index == 2:
		return "全自动模式"
	if index == 3:
		return "蓄能模式"
	return "空模式"
	
## 连接信号
func _connect_signals() -> void:
	cooldown_timer.timeout.connect(_fire_cooltime_over)
	burst_timer.timeout.connect(_on_burst_timer_timeout)
	auto_timer.timeout.connect(_fire_cooltime_over)
	
