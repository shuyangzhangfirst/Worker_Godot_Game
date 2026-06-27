class_name WeaponGun extends Weapon

## 节点引用
#region 节点引用
@onready var barrel_chamber: Marker2D = %BarrelChamber	## 枪膛
@onready var muzzle: Marker2D = %Muzzle		## 枪口
@onready var gun_fire_mode: Node = %GunFireMode	## 枪支开火模式
@onready var crosshair: Crosshair = %Crosshair	## 准星
#endregion

#region 枪械属性
@export var disable: bool = false:
	set(value):
		crosshair.visible = !value
		disable = value

@export var base_attack: int = 12				## 基础攻击力
@export var bullet_velocity:float = 600.0		## 子弹发射速度
@export var base_penetration: float = 0.0		## 枪支固定穿透力
@export var percentage_penetration: float = 0.0	## 枪支百分比穿透力
@export var handling_speed: float = 1.0			## 操作速度
@export var accuracy: float = 1.0				## 开火稳定性
@export var magazine_size: int = 120			## 弹匣容量
@export var reload_time: float = 2.0        	## 换弹时间(秒)
@export var bullet_scene: PackedScene			## 子弹场景
#endregion

var current_gun_fire_mode: GunFireMode	## 当前枪支开火模式
var trigger_pressed: bool = false	## 扳机状态
var gun_fire_mode_index: int = 0	## 开火模式索引
var gun_direction: Vector2		## 枪口朝向
var remaining_magazine: int = 30
var reload_bullet_timer: Timer	## 换弹计时器

func _ready() -> void:
	_init_gun()

func _physics_process(_delta: float) -> void:
	if disable or hit_enable==false:
		return
	if Input.is_action_just_pressed("attack"):
		current_gun_fire_mode.on_trigger_just_pressed()
		trigger_pressed = true
		
	elif Input.is_action_just_released("attack"):
		current_gun_fire_mode.on_trigger_just_release()
		trigger_pressed = false

func _process(delta: float) -> void:
	#set_gun_direction(delta)
	pass
func _shortcut_input(event: InputEvent) -> void:
	if event.is_action_pressed("change_fire_mode"):
		turn_gun_open_fire_mode()
	if event.is_action_pressed("reload_bullet"):
		print("开始换弹")
		reload_bullet_timer.start()

## 发射子弹
func shoot_bullet() -> void:
	if remaining_magazine <= 0:
		print("弹匣子弹为空")
		return
	else:
		remaining_magazine = remaining_magazine - 1
		_create_bullet()


	

func _create_bullet() -> void:
	
	var new_bullet_rotation: float
	var offset_rotation: float = (1 - accuracy) * 0.3
	new_bullet_rotation = gun_direction.angle() + randf_range(-offset_rotation, offset_rotation)
	var new_bullet_direction: Vector2 = Vector2.from_angle(new_bullet_rotation)
	
	var new_bullet: Bullet = bullet_scene.instantiate()
	new_bullet.init(muzzle.global_position, new_bullet_direction, bullet_velocity)
	new_bullet.damage = base_attack + new_bullet.bullet_attack
	new_bullet.percentage_penatration = percentage_penetration + new_bullet.percentage_bullet_penatration
	new_bullet.base_penatration = base_penetration + new_bullet.base_bullet_penatration
	GameSystem.game_wrold.prop.add_child(new_bullet)

## 设置枪支方向
func set_gun_direction(_delta: float) -> void:
	var crosshair_position: Vector2 = crosshair.global_position
	var mouse_direction: Vector2 = global_position.direction_to(crosshair_position)
	var _target_direction: Vector2 = barrel_chamber.global_position.direction_to(crosshair_position)
	var _target_rotation: float = _target_direction.angle()
	gun_direction = _target_direction
	
	if mouse_direction.x < 0:
		scale.y = -abs(scale.y)	
	else:
		scale.y = abs(scale.y)
	
	
	rotation = lerp_angle(rotation, _target_rotation, handling_speed * 0.1)
	
func _init_gun() -> void:
	if gun_fire_mode.get_children().is_empty():
		push_error("当前枪支开火模式为空，检查枪支开火模式节点是否有对应开火模式")
		return
	
	current_gun_fire_mode = gun_fire_mode.get_children()[0]
	current_gun_fire_mode.open_fire.connect(shoot_bullet)
	
	reload_bullet_timer = Timer.new()
	reload_bullet_timer.name = "换弹计时器"
	reload_bullet_timer.one_shot = true
	reload_bullet_timer.wait_time = reload_time
	reload_bullet_timer.timeout.connect(reload)
	add_child(reload_bullet_timer)
	

func reload() -> void:
	print("换弹完成")
	remaining_magazine = magazine_size

## 切换开火模式
func turn_gun_open_fire_mode() -> void:
	current_gun_fire_mode.open_fire.disconnect(shoot_bullet)
	current_gun_fire_mode.set_physics_process(false)
	
	gun_fire_mode_index = wrapi(gun_fire_mode_index + 1 ,0 ,gun_fire_mode.get_children().size())
	current_gun_fire_mode = gun_fire_mode.get_children()[gun_fire_mode_index]
	current_gun_fire_mode.open_fire.connect(shoot_bullet)
	print("开火模式切换为: " + current_gun_fire_mode.fire_mode_name)

func get_gun_muzzle_distance() -> float:
	return global_position.distance_to(muzzle.global_position)
