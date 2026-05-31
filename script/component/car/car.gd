extends Character
class_name Car

signal drive_car
signal not_drive_car
var all_directions:Array[Vector2]=[Vector2.RIGHT,Vector2(1,1),Vector2.DOWN,Vector2(-1,1),Vector2.LEFT,Vector2(-1,-1),Vector2.UP,Vector2(1,-1)]
var input_direction:Vector2
var angle:float =0
@export var rotation_speed:float #转向速度
@export var acceleration:float #加速度
@export var stop:float#停止
@export var to_break:float#刹车
@export var max_speed:float #最大速度
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: StateMachine = $StateMachine
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D
@onready var playerdedectarea: Area2D = $playerdedectarea

@onready var hitbox_front: Hitbox = $Hitbox_front
@onready var hitbox_back: Hitbox = $Hitbox_back

var choose_speed:Array
var speed:float #目前车辆的速度
var animation_direction:Vector2
@export var animation_player:AnimationPlayer

func _ready() -> void:
	super._ready()
	choose_speed=[acceleration,acceleration,to_break]
	
	

func enable_car():
	process_mode = Node.PROCESS_MODE_INHERIT

func disable_car():
	process_mode=Node.PROCESS_MODE_DISABLED
	

func update_collision_direction():
	collision_shape_2d.rotation = move_direction.angle()
func update_hit_box():
	hitbox_front.rotation = move_direction.angle()
	
	hitbox_back.rotation = move_direction.angle()
	if speed>0:
		hitbox_front.monitorable=true
		hitbox_back.monitorable=false
	elif speed<0:
		hitbox_front.monitorable=false
		hitbox_back.monitorable=true
	else:
		hitbox_front.monitorable=false
		hitbox_back.monitorable=false
func get_move_vector(delta)->Vector2:
	
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
	if speed !=0:
		angle += input_direction.x*rotation_speed *delta
		angle  = fposmod(angle, TAU)
		var dir_index = int(round(angle / (TAU / 8.0)))%8
		move_direction= all_directions[dir_index]
	
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
		

		
