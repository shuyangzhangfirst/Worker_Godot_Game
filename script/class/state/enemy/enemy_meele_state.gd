extends EnemyState
class_name EnemyMeeleState

@export var hit_box:Hitbox
var animation_finished:bool

func Enter():
	
	var direction=character.VectorToDirection(character.anim_direction)
	character.UpdateAnimation(state_name,direction)
	animation_finished=false
	enemy.hit_box.global_position= player.global_position
	character.animationplayer.animation_finished.connect(attack_animation_finished)
	
	

func attack_animation_finished(_anim):
	
	animation_finished=true
	
func Physic(_delta:float):
	
	if animation_finished:
		character.statemachine.SwitchState(statemachine.states[StateConstands.State.idle])
	
func Exit():
	hit_box.enable_hitbox(false)
	character.animationplayer
	character.animationplayer.animation_finished.disconnect(attack_animation_finished)
	
