class_name PlayerWalkState extends PlayerState
@export var  move_speed: float
@export var run_speed:float
var run_animation_speed:float
var is_running
func Init():
	run_animation_speed=run_speed/move_speed

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
	character.animationplayer.speed_scale=1
func _on_drive_car():
	statemachine.SwitchState(statemachine.states[StateConstands.State.disable])
	



		
	

func Physic(delta:float):
	super.Physic(delta)
	if	character.move_direction == Vector2.ZERO:
		
		statemachine.SwitchState(statemachine.states[StateConstands.State.idle])
		return
	if Input.is_action_pressed("run"):
		character.velocity = character.move_direction * run_speed
		character.animationplayer.speed_scale=run_animation_speed
	else:	
		character.velocity = character.move_direction * move_speed
		character.animationplayer.speed_scale=1
	
	if character.ShouldUpdateAnimationDirection():
		
		var direction=character.VectorToDirection(character.anim_direction)
		character.UpdateAnimation(state_name,direction)
	
	character.move_and_slide()

		
