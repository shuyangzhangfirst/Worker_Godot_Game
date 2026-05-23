extends Hitbox
class_name  BulletHitbox

signal bullet_destroyed

@export var percentage_penatration:float ##百分比穿透
@export var base_penatration:float ##固定穿透

func calculate_damage(character:Character)->float:
	if character is Player:
		return damage
	elif character is Enemy:
		character.current_defense -= character.max_defense*percentage_penatration
		character.current_defense -= base_penatration
		if character.current_defense>=0:
			self.queue_free()
			return max(damage - character.current_defense,1)
		else:
			var final_damage=damage
			damage*=0.5
			return final_damage
			
	else:
		return damage
