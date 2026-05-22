class_name Character extends CharacterBody2D

@export var animationplayer:AnimationPlayer
@export var sprite:Sprite2D
@export var statemachine:StateMachine

@export var effect_animation_player:AnimationPlayer # 受伤特效的animation
var move_direction:Vector2
var anim_direction:Vector2

func _ready() -> void:
	statemachine.Initialize(self)
	anim_direction=Vector2.DOWN
	
	pass

func UpdateAnimation(animation:String,direction:String=""):
	if direction=="":
		animationplayer.play(animation)
	else:
		animationplayer.play(animation+"_"+direction)
	HandleFlip()
	
	
	
func ShouldUpdateAnimationDirection()->bool:
	
	var new_anim_direction=anim_direction
	if new_anim_direction==move_direction:
		return false
	if move_direction==Vector2.ZERO:
		return false
	if move_direction.x==0:
		new_anim_direction=Vector2.UP if move_direction.y<0 else Vector2.DOWN
	elif move_direction.y==0:
		new_anim_direction=Vector2.LEFT if move_direction.x<0 else Vector2.RIGHT
	else:
		
		if (anim_direction==Vector2.LEFT and move_direction.x<0) or (anim_direction==Vector2.RIGHT and move_direction.x>0) or (anim_direction==Vector2.UP and move_direction.y>0) or (anim_direction==Vector2.DOWN and move_direction.y<0):
			new_anim_direction=anim_direction*-1
		
		
		
		
				
				
	if new_anim_direction == anim_direction:
		
		return false
	else:
		
		anim_direction=new_anim_direction
		return true
		
			
			

func VectorToDirection(vector:Vector2):
	if vector == Vector2.UP:
		return "up"
	elif vector == Vector2.DOWN:
		return "down"
	else:
		return "side"
func HandleFlip():
	if move_direction.x == 0:
		return
	
	if (anim_direction.x * self.scale.x)<0 or anim_direction.x!=0:
		
		sprite.scale.x=-1 if move_direction.x<0 else 1
	

func TakeDamage(hitbox:Hitbox):
	
	pass

## 切换动画播放方向
func change_ani_dir(dir: Vector2) -> void:
	var dir_name: String = VectorToDirection(dir)
	UpdateAnimation(statemachine.current_state.state_name, dir_name)
