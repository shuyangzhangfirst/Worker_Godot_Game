@tool
extends Line2D
class_name GunWire

@export var gun_wire_preview: bool = false	## 枪线预览

@export var barrel_chamber: Marker2D	## 弹膛位置
@export var muzzle: Marker2D	## 枪口位置

func _ready() -> void:
	pass
	
func _process(_delta: float) -> void:
	if barrel_chamber and muzzle:
		visible = true
		if Engine.is_editor_hint():
			position = Vector2.ZERO
			set_point_position(0, barrel_chamber.position)
			set_point_position(1, muzzle.position)
		elif gun_wire_preview:
			position = Vector2.ZERO
			set_point_position(0, barrel_chamber.position)
			set_point_position(1, muzzle.position + get_barrel_direction())
		else:
			visible = false
			
			
## 返回枪管朝向向量
func get_barrel_direction() -> Vector2:
	return barrel_chamber.global_position.direction_to(muzzle.global_position)
