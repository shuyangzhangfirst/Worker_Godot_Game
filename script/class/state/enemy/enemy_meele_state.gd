extends EnemyState
class_name EnemyMeeleState

@export var hit_box:Hitbox
var animation_finished:bool
@export var hit_box_enable_frame:int
func Enter():
	
	var direction=character.VectorToDirection(character.anim_direction)
	character.UpdateAnimation(state_name,direction)
	animation_finished=false
	enemy.hit_box.global_position= player.global_position
	enemy.animatesprite.animation_finished.connect(attack_animation_finished)
	enemy.animatesprite.frame_changed.connect(hurtbox_on)
	
	
func hurtbox_on():
	
	if enemy.animatesprite.frame == hit_box_enable_frame:
		
		hit_box.enable_hitbox(true)
func attack_animation_finished():
	hit_box.enable_hitbox(false)
	animation_finished=true
	
func Physic(_delta:float):
	
	if animation_finished:
		character.statemachine.SwitchState(statemachine.states[StateConstands.State.idle])
	
func Exit():
	
	
	character.animatesprite.animation_finished.disconnect(attack_animation_finished)
	enemy.animatesprite.frame_changed.disconnect(hurtbox_on)
