class_name  PlayerIdleState extends PlayerState

func Enter():
	
	character.drive_car.connect(_on_drive_car)
	var direction = character.VectorToDirection(character.anim_direction)
	character.UpdateAnimation(state_name,direction)
func Exit():
	character.drive_car.disconnect(_on_drive_car)
func _on_drive_car():
	statemachine.SwitchState(statemachine.states[StateConstands.State.disable])
func Physic(delta:float):
	super.Physic(delta)
	
	if character.move_direction!=Vector2.ZERO:
		statemachine.SwitchState(statemachine.states[StateConstands.State.walk])
		return
	
