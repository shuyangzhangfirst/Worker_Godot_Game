extends Node2D
class_name Throwable

@export var throw_speed:float=100 #扔的速度
@export var max_height:float=0 # z 轴力量
@export var max_throw_distance:float = -1
@export var explosive_wait_time:float=0
@onready var hitbox: Hitbox = $Hitbox

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
var is_explosion=false

var target_global_position:Vector2

var target_distance:float
var target_direction:Vector2




var fly_distance=0

var current_height_speed=0
func _ready() -> void:
	calculate_parameters()
	hitbox.enable_hitbox(false)
func _physics_process(delta: float) -> void:
	if is_explosion:
		return
	if max_height:
		
		var move_distance=delta*throw_speed
		fly_distance+=move_distance
		if fly_distance>=target_distance:
			global_position+=(target_direction*move_distance)
			sprite_2d.position=Vector2(0,0)
			explosion()
		else:
			
			sprite_2d.position=Vector2(0,-calculate_height(delta))
			global_position+=(target_direction*move_distance)
	else:
		var move_distance=delta*throw_speed
		fly_distance+=move_distance
		global_position+=(target_direction*move_distance)
		if fly_distance >= target_distance:
			explosion()
		
		
		

func explosion():
	is_explosion=true
	await get_tree().create_timer(explosive_wait_time).timeout
	animation_player.play("explosive")
	
	await animation_player.animation_finished
	queue_free()
		

func calculate_height(delta):
	
	
	return -(4*max_height/pow(target_distance,2))\
	*pow(fly_distance-(target_distance)/2,2) \
	+max_height
	
	
func calculate_parameters():
	target_direction= global_position.direction_to(target_global_position)
	target_distance=global_position.distance_to(target_global_position)
	
	
	
	
