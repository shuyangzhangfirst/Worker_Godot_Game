
class_name EnemyChaseState extends EnemyState

@export var navigation_agent_2d: NavigationAgent2D 

var update_timer:float
@export var update_interval:float
@export var max_chase_duration:float #玩家丢失视野后继续追逐的时间
var chase_timer:float
@export var chase_area_range:Vector2
func Enter():
	navigation_agent_2d.target_position=player.global_position
	update_timer=update_interval
	chase_player()
	character.hurt_box.TakeDamage.connect(take_damage)
	enemy.chase_area.scale=chase_area_range
	character.ShouldUpdateAnimationDirection()
	chase_timer=max_chase_duration
	var direction=character.VectorToDirection(character.anim_direction)
	
	enemy.UpdateAnimation(state_name,direction,enemy.chase_speed/enemy.walk_speed)
	
	character.move_and_slide()
func Exit():
	enemy.chase_area.scale=Vector2(1,1)	
	character.hurt_box.TakeDamage.disconnect(take_damage)
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
	if not enemy.chase_area_has_player():
		chase_timer-=_delta
		if chase_timer<=0:
			character.statemachine.SwitchState(character.statemachine.states[StateConstands.State.idle])
			return
	else:	
		chase_timer=max_chase_duration
	
	
		
	if update_timer<=0:
		navigation_agent_2d.target_position=player.global_position
		update_timer=update_interval
	
	chase_player()
	
	if character.ShouldUpdateAnimationDirection():
		
		var direction=character.VectorToDirection(character.anim_direction)
		
		enemy.UpdateAnimation(state_name,direction,enemy.chase_speed/enemy.walk_speed)
	character.move_and_slide()
	update_timer-=_delta
	
func take_damage(hit_box:Hitbox):
	
	if hit_box.knock_back_duration>0:
		
		statemachine.Switch_State_With_Parameter(statemachine.states[StateConstands.State.TakeHit],[hit_box])
