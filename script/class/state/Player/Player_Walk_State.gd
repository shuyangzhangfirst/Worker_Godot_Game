class_name PlayerWalkState extends PlayerState


var is_running
@export var running_energy_cost = 20
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
	
	if Input.is_action_pressed("run") and character.player_stats.current_energy.get_value()>0:
		character.velocity = character.move_direction * character.player_stats.run_speed.get_value()
		character.player_stats.current_energy.add_value(-running_energy_cost*delta)
		character.player_stats.player_just_cost_energy()
		character.animationplayer.speed_scale=character.player_stats.run_speed.get_value()/character.player_stats.walk_speed.get_value()
	else:	
		
		character.velocity = character.move_direction * character.player_stats.walk_speed.get_value()
		character.animationplayer.speed_scale=1
	
	if character.ShouldUpdateAnimationDirection():
		
		var direction=character.VectorToDirection(character.anim_direction)
		character.UpdateAnimation(state_name,direction)
	
	character.move_and_slide()

		
