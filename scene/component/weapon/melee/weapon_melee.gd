extends Weapon
class_name WeaponMelee

@onready var hitbox: Hitbox = %Hitbox
@onready var animation_player: AnimationPlayer = %AnimationPlayer

func use
