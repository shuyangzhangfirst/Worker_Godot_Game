class_name Hitbox extends Area2D



var damage:float
@export_category("击退信息")
@export var knock_back_velocity=0 #击退速度，建议100
@export var knock_back_duration=0 #击退持续时间
@export var knock_back_fall_off=0 #击退减速，值越大，减速越快
@export var collision_shape:CollisionShape2D

func enable_hitbox(enable):
	collision_shape.disabled= !enable

func calculate_damage(character:Character) ->float:
	return damage
