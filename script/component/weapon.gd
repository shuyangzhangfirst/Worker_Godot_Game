extends Node2D
class_name Weapon

@export var weapon_name: String = ""	## 武器名称
@export var weapon_type: WeaponType	## 武器类型
var hit_enable:bool = true##武器是否可以开火，例如被打时不能开火
## 武器类型
enum WeaponType {
	远程,	## 远程类型
	近战,	## 近身类型
}
