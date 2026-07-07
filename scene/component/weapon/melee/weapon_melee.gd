extends Weapon
class_name WeaponMelee
signal meele_attack_started
signal meele_attack_finished
@onready var hitbox: Hitbox = %Hitbox
@onready var animation_player: AnimationPlayer = %AnimationPlayer

func _ready() -> void:
	hitbox.enable_hitbox(false)

func melee_attack() -> void:
	if hit_enable ==false:
		return
	meele_attack_started.emit()
	hitbox.enable_hitbox(true)
	animation_player.play("attack")
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		hitbox.enable_hitbox(false)
		meele_attack_finished.emit()
