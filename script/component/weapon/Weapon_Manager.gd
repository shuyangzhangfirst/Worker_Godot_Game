extends Node2D
class_name  WeaponManager



enum Hands{
	left,
	right,
	both
}
@export var gun_scene:PackedScene
@export var meele_scene:PackedScene
@onready var meele: Node2D = $meele
@onready var gun: Node2D = $gun


var direction:Vector2
var gun_weapon:WeaponGun
var meele_weapon:Weapon

func _ready() -> void:
	
	if gun_scene:
		change_weapon(gun_scene)
	if meele_scene:
		change_weapon(meele_scene)
func _unhandled_input(event: InputEvent) -> void:
	pass
	#if (gun_weapon and event.is_action_pressed("attack")):
		#print(gun_weapon.position)
		#gun_weapon.shoot_bullet()

func change_weapon(weapon:PackedScene):
	 
	var weapon_scene= weapon.instantiate()
	if weapon_scene is WeaponGun:
		
		if gun_weapon:
			
			gun_weapon.queue_free()
		gun_weapon=weapon_scene as WeaponGun
		gun.add_child(weapon_scene)
		
		
		
func get_mouse_direction():
	return (get_global_mouse_position() - global_position).normalized()
func _physics_process(delta: float) -> void:
	direction = get_mouse_direction()
	rotation=direction.angle()
	
	pass
