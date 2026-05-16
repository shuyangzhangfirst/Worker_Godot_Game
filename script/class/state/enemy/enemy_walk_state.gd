extends EnemyState
class_name  EnemyWalkState

var walk_interval:float
var max_walk_times:int
var next_direction : Vector2
var direction=[Vector2.UP,Vector2.DOWN,Vector2.LEFT,Vector2.RIGHT]
func Enter():
	max_walk_times = randi_range(3,5)
	walk_interval=0
	
func Physic(_delta:float):
	if enemy.meele_area_has_player():
		character.statemachine.SwitchState(statemachine.states[StateConstands.State.meele])
	elif enemy.chase_area_has_player():
		character.statemachine.SwitchState(statemachine.states[StateConstands.State.enemy_chase])
	elif max_walk_times<=0:
		
		character.statemachine.SwitchState(statemachine.states[StateConstands.State.idle])
	
	if walk_interval<=0:
		next_direction=direction[randi_range(0,3)]
		walk_interval=randf_range(1,3)
		max_walk_times-=1
	walk_interval-=_delta
	character.move_direction=next_direction
	
	character.velocity=character.move_direction*enemy.walk_speed
	
	if character.ShouldUpdateAnimationDirection():
		
		var direction=character.VectorToDirection(character.anim_direction)
		
		character.UpdateAnimation(state_name,direction)
	character.move_and_slide()
	
	
	
	
