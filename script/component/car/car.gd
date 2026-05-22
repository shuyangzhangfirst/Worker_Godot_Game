extends CharacterBody2D
class_name car

signal drive_car
signal not_drive_car
var all_directions:Array[Vector2]=[Vector2.RIGHT,Vector2(1,1),Vector2.DOWN,Vector2(-1,1),Vector2.LEFT,Vector2(-1,-1),Vector2.UP,Vector2(1,-1)]
var input_direction:Vector2
var angle:float =0
var move_direction:Vector2=Vector2.RIGHT
@export var rotation_speed:float #转向速度
@export var acceleration:float #加速度
@export var stop:float#停止
@export var to_break:float#刹车
@export var max_speed:float #最大速度
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


var choose_speed:Array
var speed:float #目前车辆的速度
var animation_direction:Vector2
@export var animation_player:AnimationPlayer

func _ready() -> void:
	choose_speed=[acceleration,acceleration,to_break]
	
	

func enable_car():
	process_mode = Node.PROCESS_MODE_INHERIT

func disable_car():
	process_mode=Node.PROCESS_MODE_DISABLED
	

func _physics_process(delta: float) -> void:
	input_direction=Vector2(
	Input.get_axis("Left", "Right"),
	Input.get_axis("Up", "Down")
	)
	var v =get_move_vector(delta)
	velocity=v
	animated_sprite_2d.play(match_animation_direction(move_direction))
	move_and_slide()
	
func get_move_vector(delta)->Vector2:
	angle += input_direction.x*rotation_speed *delta
	angle  = fposmod(angle, TAU)
	var dir_index = int(round(angle / (TAU / 8.0)))%8
	move_direction= all_directions[dir_index]
	var speed_factor=0
	
	if input_direction.y!=0:
		
		speed_factor = choose_speed[1+input_direction.y*sign(speed)] *input_direction.y*-1
		
	else:
		
		speed_factor = sign(speed)*stop*-1
		
	var acc= speed_factor* delta
	if input_direction.y==0:
		if speed>0:
			speed=clamp(speed+acc,0,max_speed)
		elif speed<0:
			speed = clamp(speed+acc,-max_speed,0)
	else:
		speed=clampf(speed+acc,-max_speed,max_speed)
	return move_direction.normalized()*speed


	
func match_animation_direction(direction:Vector2)-> String:
	match direction:
		Vector2.RIGHT: return "right"
		Vector2.LEFT : return "left"
		Vector2.DOWN:return "down"
		Vector2.UP : return "up"
		Vector2(1,1): return "down_right"
		Vector2(-1,1):return "down_left"
		Vector2(1,-1):return "up_right"
		Vector2(-1,-1): return "up_left"
		_: return "right"
		
		
