class_name PlayerWalkState extends PlayerState
@export var  move_speed: float

func Enter():
	
	
	character.ShouldUpdateAnimationDirection()
	var direction=character.VectorToDirection(character.move_direction)
	character.UpdateAnimation(state_name,direction)
	
	



		
	

func Physic(delta:float):
	super.Physic(delta)
	if	character.move_direction == Vector2.ZERO:
		
		statemachine.SwitchState(statemachine.states[StateConstands.State.idle])
		return
	
	character.velocity = character.move_direction * move_speed
	
	if character.ShouldUpdateAnimationDirection():
		
		var direction=character.VectorToDirection(character.anim_direction)
		character.UpdateAnimation(state_name,direction)
	
	character.move_and_slide()
	
