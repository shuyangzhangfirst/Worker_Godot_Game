class_name Enemy extends Character

## 敌人所需要的组件




## 敌人的属性，不用如主角那样复杂，当然后面可以看吧
@export var current_hp:float=10
@export var max_hp:float=10

## 敌人的一些其他东西
@export var walk_speed:float
@export var chase_speed:float

@export var chase_area:ChaseArea
@export var meele_area:AttackArea

@export var hit_box :Hitbox
@export var hurt_box:Hurtbox

func chase_area_has_player():
	return chase_area.get_overlapping_bodies().has(GameSystem.DataDataManager.current_player)
func meele_area_has_player():
	return meele_area.get_overlapping_bodies().has(GameSystem.DataDataManager.current_player)
func TakeDamage(hitbox:Hitbox):
	current_hp = max(0,current_hp- hitbox.damage)
	effect_animation_player.play("takedamage")
	print(current_hp)	
	
	print(current_hp)
	#invulnerable=true
	#await  get_tree().create_timer(1).timeout
	invulnerable=false
	
func ShouldUpdateAnimationDirection()->bool:
	if move_direction==Vector2.ZERO:
		return false
	var is_side=(abs(move_direction.y)-abs(move_direction.x))<0
	
	var new_anim_direction=Vector2.RIGHT if is_side else Vector2.DOWN
	
	new_anim_direction = (new_anim_direction * move_direction).normalized()
	if new_anim_direction==Vector2.ZERO or new_anim_direction==anim_direction:
		
		return false
	else:
		
		anim_direction=new_anim_direction
		return true
	
func VectorToDirection(vector:Vector2):
	if vector == Vector2.UP:
		return "up"
	elif vector == Vector2.DOWN:
		return "down"
	else:
		return "side"
	
	hitbox.invulnerable=true
	await  get_tree().create_timer(1).timeout
	hitbox.invulnerable=false
