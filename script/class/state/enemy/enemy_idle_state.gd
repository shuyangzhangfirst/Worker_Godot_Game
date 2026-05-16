extends EnemyState
class_name EnemyIdleState

var idle_timer:float
func Enter():
	
	character.velocity=Vector2.ZERO
	var direction=character.VectorToDirection(character.anim_direction)
	idle_timer=randf_range(1,3)
	
		
	character.UpdateAnimation(state_name,direction)

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

	



	
