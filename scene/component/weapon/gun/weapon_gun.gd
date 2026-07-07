extends Weapon
class_name WeaponGun



@onready var gun_wire: GunWire = %GunWire			## 枪械方向辅助枪线
@onready var gun_fire_mode: Node = %GunFireMode		## 开火模式容器

@export_category("枪械属性")
@export var exit_velocity: float = 600.0			## 子弹出口速度
@export var spread: float = 0.0						## 子弹扩散(角度)
@export var reload_time: float = 2.0        		## 换弹时间(秒)
@export var	magazine_size: int = 30					## 弹匣容量

var magazine_array: Array[MagazineBullet]	## 弹匣数组
var current_gun_fire_mode: GunFireMode		## 当前枪支开火模式
var gun_fire_mode_index: int = 0			## 开火模式索引

func _ready() -> void:
	_init_weapon_gun()
	_connect_signal()

## 测试用


## 扳机按下
func trigger_on() -> void:
	current_gun_fire_mode.on_trigger_just_pressed()

## 扳机松开
func trigger_off() -> void:
	current_gun_fire_mode.on_trigger_just_release()

## 发射子弹
func shoot_bullet() -> void:
	if magazine_array.is_empty() :
		print("弹匣为空")
		return
	if hit_enable == false:
		return
	var bullet: Bullet = _create_bullet(magazine_array.pop_back())
	
	# 加入场景
	#GameSystem.game_wrold.prop.add_child(bullet)
	add_child(bullet)
	bullet.global_position=gun_wire.muzzle.global_position

## 将物品加载为弹匣内子弹
func loading_magazine(item_bullet: ItemBullet) -> void:
	if magazine_array.size() >= magazine_size:
		return
		
	var new_magezine_bullet: MagazineBullet = MagazineBullet.new()
	new_magezine_bullet.buttlet_scene = item_bullet.bullet_scene
	magazine_array.append(new_magezine_bullet)

## 切换到下一个开火模式
func change_fire_mode() -> void:
	if gun_fire_mode.get_children().size() <= 1:
		return
	
	current_gun_fire_mode.shoot_bullet.disconnect(shoot_bullet)
	current_gun_fire_mode.on_trigger_just_release()
	
	var next_index: int = wrapi(gun_fire_mode_index + 1, 0, gun_fire_mode.get_children().size())
	current_gun_fire_mode = gun_fire_mode.get_children()[next_index]
	gun_fire_mode_index = next_index
	
	current_gun_fire_mode.shoot_bullet.connect(shoot_bullet)
	
	print("切换开火模式: ", current_gun_fire_mode.get_fire_mode_name_string())

## 初始化枪械
func _init_weapon_gun() -> void:
	current_gun_fire_mode = gun_fire_mode.get_children()[0]
	_full_magezine_test()
	
## 创建新子弹
func _create_bullet(bullet: MagazineBullet) -> Bullet:
	var new_bullet: Bullet = bullet.buttlet_scene.instantiate()
	new_bullet.damage = new_bullet.bullet_attack + base_attack 
	new_bullet.percentage_penatration = new_bullet.percentage_bullet_penatration + percentage_penetration
	new_bullet.base_penatration = new_bullet.base_bullet_penatration + base_penetration
	
	
	
	new_bullet.bullet_flight_speed = exit_velocity
	
	
	var gun_wire_rotaion: float = gun_wire.get_barrel_direction().angle()
	var bullet_rotation: float = gun_wire_rotaion + deg_to_rad(randf_range(-spread, spread))
	new_bullet.flight_direction = Vector2.from_angle(bullet_rotation)
	
	return new_bullet

func _full_magezine_test() -> void:
	while magazine_array.size() < magazine_size:
		var bullet_scene: PackedScene = preload("uid://c5c74061iw76w")
		var new_item_bullet: ItemBullet = ItemBullet.new()
		new_item_bullet.bullet_scene = bullet_scene
		loading_magazine(new_item_bullet)

func _connect_signal() -> void:
	#get_parent().trigger_on.connect(trigger_on)
	#get_parent().trigger_off.connect(trigger_off)
	current_gun_fire_mode.shoot_bullet.connect(shoot_bullet)
	
