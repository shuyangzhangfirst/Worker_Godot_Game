extends Node2D
class_name Weapon

@export_category("武器信息")
@export var weapon_name: String = ""			## 武器名称
@export var weapon_type: WeaponType				## 武器类型

@export_category("武器属性")
@export var base_attack: float = 1.0			## 武器基础攻击力
@export var base_penetration: float = 0.0		## 固定穿透力
@export var percentage_penetration: float = 0.0	## 百分比穿透力
@export var handling_speed: float = 1.0			## 操作速度

var hit_enable: bool = true				##武器是否可以开火，例如被打时不能开火

## 武器类型
enum WeaponType {
	远程,	## 远程类型
	近战,	## 近身类型
}

## 旋转武器为指定方向
#func rotating_weapon(dir: Vector2) -> void:
	#var radians: float = dir.angle()
	#container.rotate(radians)
	#
	#var scale_x: float = absf(container.scale.x)
	#
	#container.scale.x = scale_x if dir.x > 0 else -scale_x
