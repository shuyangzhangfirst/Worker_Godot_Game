class_name Hitbox extends Area2D



var damage:float
@export var collision_shape:CollisionShape2D

func enable_hitbox(enable):
	collision_shape.disabled= !enable

func calculate_damage(character:Character) ->float:
	return damage
