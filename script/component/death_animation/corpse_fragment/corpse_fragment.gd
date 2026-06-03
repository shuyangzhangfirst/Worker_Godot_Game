extends RigidBody2D
class_name CorpseFragment

@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D

@export var linear_damping: float = 2.0	## 线性阻尼（速度衰减）
@export var angular_damping: float = 3.0	## 角阻尼（旋转衰减）
@export var lifetime: float = 5.0	## 存在时间（秒）

var _lifetime_timer: float = 0.0


func _ready() -> void:
	# 设置物理属性
	# 注意：需要在编辑器中设置 damping 值，或者通过代码设置
	# linear_damping 和 angular_damping 会自动应用到 RigidBody2D
	
	# 启用连续碰撞检测，防止穿透
	collision_layer = 1
	collision_mask = 1
	
	# 设置初始状态
	sleeping = false  # 初始不进入睡眠状态

func _process(delta: float) -> void:
	_lifetime_timer += delta
	
	# 超过生命周期后自动销毁
	if _lifetime_timer >= lifetime:
		queue_free()

## 设置纹理
func set_texture(texture: Texture2D) -> void:
	sprite_2d.texture = texture

## 设置随机旋转
func set_random_rotation() -> void:
	rotation = randf_range(0, TAU)

## 设置大小
func set_scale_factor(scale_factor: float) -> void:
	sprite_2d.scale = Vector2.ONE * scale_factor
	if collision_shape_2d and collision_shape_2d.shape:
		collision_shape_2d.shape.radius = collision_shape_2d.shape.radius * scale_factor
