extends PlayerState
class_name PlayerTakeHitState

@export var hurt_box:Hurtbox
var hit_box:Hitbox
var knock_back_velocity:float 
var knock_back_timer
var knock_back_direction:Vector2
var knock_back_fall_off:float


func take_another_damage(hit_box:Hitbox):
	if hit_box.knock_back_duration>0:
		statemachine.Switch_State_With_Parameter(statemachine.states[StateConstands.State.TakeHit],[hit_box])

func Enter_With_Parameter(para:Array):
	
	if para :
		
		hit_box=para[0]
		hurt_box.TakeDamage.connect(take_another_damage)
		knock_back_timer=hit_box.knock_back_duration
		knock_back_velocity=hit_box.knock_back_velocity
		knock_back_direction=get_knock_back_direction()
		knock_back_fall_off=hit_box.knock_back_fall_off
		if knock_back_direction==Vector2.ZERO:
			knock_back_direction= hit_box.get_parent().global_position.direction_to(hurt_box.global_position)
		character.move_direction=knock_back_direction
		
		character.ShouldUpdateAnimationDirection()
		var direction=character.VectorToDirection(character.anim_direction)
		
		character.UpdateAnimation(state_name,direction)
		
	else:
		statemachine.SwitchState(statemachine.states[StateConstands.State.idle])

func Exit():
	
	hurt_box.TakeDamage.disconnect(take_another_damage)
	
func Physic(_delta:float):
	
	if knock_back_timer<=0:
		statemachine.SwitchState(statemachine.states[StateConstands.State.idle])
	knock_back_timer-=_delta
	character.velocity=knock_back_direction*knock_back_velocity
	knock_back_velocity-=knock_back_fall_off*_delta
	

	character.move_and_slide()

func get_knock_back_direction():
	return hit_box.global_position.direction_to(hurt_box.global_position)
	
