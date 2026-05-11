extends Node2D
class_name Weapon

@export var weapon_name: String = ""	## 武器名称
@export var weapon_type: WeaponType	## 武器类型

## 武器类型
enum WeaponType {
	远程,	## 远程类型
	近战,	## 近身类型
}
