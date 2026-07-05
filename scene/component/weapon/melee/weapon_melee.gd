extends Weapon
class_name WeaponMelee

@onready var hitbox: Hitbox = %Hitbox
@onready var animation_player: AnimationPlayer = %AnimationPlayer

func _ready() -> void:
	hitbox.enable_hitbox(false)

func melee_attack() -> void:
	hitbox.enable_hitbox(true)
	animation_player.play("attack")
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		hitbox.enable_hitbox(false)
