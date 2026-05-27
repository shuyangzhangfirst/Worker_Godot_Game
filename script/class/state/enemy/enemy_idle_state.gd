extends EnemyState
class_name EnemyIdleState

var idle_timer:float
func Enter():
	
	character.velocity=Vector2.ZERO
	var direction=character.VectorToDirection(character.anim_direction)
	idle_timer=randf_range(1,3)
	
	character.hurt_box.TakeDamage.connect(take_damage)
	character.UpdateAnimation(state_name,direction)
func Exit():
	character.hurt_box.TakeDamage.disconnect(take_damage)
func Physic(_delta:float):
	
	if enemy.meele_area_has_player():
		statemachine.SwitchState(statemachine.states[StateConstands.State.meele])
		return
	elif enemy.chase_area_has_player():
		
		statemachine.SwitchState(statemachine.states[StateConstands.State.enemy_chase])
		return 
	elif idle_timer<=0:
		statemachine.SwitchState(statemachine.states[StateConstands.State.walk])
	idle_timer-=_delta

func take_damage(hit_box:Hitbox):
	
	if hit_box.knock_back_duration>0:
		
		statemachine.Switch_State_With_Parameter(statemachine.states[StateConstands.State.TakeHit],[hit_box])	



	
