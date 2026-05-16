class_name  PlayerIdleState extends PlayerState

func Enter():
	
	
	var direction = character.VectorToDirection(character.anim_direction)
	character.UpdateAnimation(state_name,direction)
	

func Physic(delta:float):
	super.Physic(delta)
	
	if character.move_direction!=Vector2.ZERO:
		statemachine.SwitchState(statemachine.states[StateConstands.State.walk])
		return
	
