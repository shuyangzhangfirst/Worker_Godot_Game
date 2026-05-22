
class_name EnemyChaseState extends EnemyState

@export var navigation_agent_2d: NavigationAgent2D 

var update_timer:float
@export var update_interval:float

@export var chase_area_range:Vector2
func Enter():
	navigation_agent_2d.target_position=player.global_position
	update_timer=update_interval
	chase_player()
	
	enemy.chase_area.scale=chase_area_range
	character.ShouldUpdateAnimationDirection()
	
	var direction=character.VectorToDirection(character.anim_direction)
	
	enemy.UpdateAnimation(state_name,direction,enemy.chase_speed/enemy.walk_speed)
	
	character.move_and_slide()
func Exit():
	enemy.chase_area.scale=Vector2(1,1)	
func get_next_position():
	
	var next_pos = navigation_agent_2d.get_next_path_position()
	
	return (next_pos-character.global_position).normalized()

	
	
func chase_player():
	if navigation_agent_2d.is_navigation_finished():
		
		return
	
	enemy.move_direction = get_next_position()
	
	enemy.velocity=enemy.move_direction*enemy.chase_speed
	

func Physic(_delta:float):
	if enemy.meele_area_has_player():
		character.statemachine.SwitchState(character.statemachine.states[StateConstands.State.meele])
		return 
	elif not enemy.chase_area_has_player():
		character.statemachine.SwitchState(character.statemachine.states[StateConstands.State.idle])
		return
	
		
	if update_timer<=0:
		navigation_agent_2d.target_position=player.global_position
		update_timer=update_interval
	
	chase_player()
	
	if character.ShouldUpdateAnimationDirection():
		
		var direction=character.VectorToDirection(character.anim_direction)
		
		enemy.UpdateAnimation(state_name,direction,enemy.chase_speed/enemy.walk_speed)
	character.move_and_slide()
	update_timer-=_delta
	
