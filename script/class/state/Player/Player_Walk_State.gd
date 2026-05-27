class_name PlayerWalkState extends PlayerState
@export var  move_speed: float

func Enter():
	character.drive_car.connect(_on_drive_car)
	character.hurt_box.TakeDamage.connect(take_damage)
	character.ShouldUpdateAnimationDirection()
	var direction=character.VectorToDirection(character.move_direction)
	character.UpdateAnimation(state_name,direction)
func take_damage(hit_box:Hitbox):
	if hit_box.knock_back_duration>0:
		statemachine.Switch_State_With_Parameter(statemachine.states[StateConstands.State.TakeHit],[hit_box])
func Exit():
	character.drive_car.disconnect(_on_drive_car)
	character.hurt_box.TakeDamage.disconnect(take_damage)
func _on_drive_car():
	statemachine.SwitchState(statemachine.states[StateConstands.State.disable])
	



		
	

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
	
