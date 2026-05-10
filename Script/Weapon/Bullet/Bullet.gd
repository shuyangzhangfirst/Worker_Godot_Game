class_name Bullet extends Area2D

@export var bullet_speed:float = 100
@export var bullet_duration:float=3
var dir:Vector2
func _ready() -> void:
	dir = Vector2.RIGHT.rotated(rotation)
	
	
func _physics_process(delta: float) -> void:
	global_position += dir*bullet_speed*delta
	bullet_duration-=delta
	if bullet_duration<=0:
		queue_free()
	
