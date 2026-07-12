extends Node2D
class_name  WeaponManager



enum Hands{
	left,
	right,
	both
}
@export var gun_scene:PackedScene
@export var meele_scene:PackedScene
@export var throwable_scene:PackedScene
@export var remain_throwable:int
@onready var meele: Node2D = $meele
@onready var gun: Node2D = $gun
@onready var throwable: Node2D = $throwable


var direction:Vector2
var gun_weapon:WeaponGun
var meele_weapon:WeaponMelee

func _ready() -> void:
	
	if gun_scene:
		change_weapon(gun_scene)
	if meele_scene:
		change_weapon(meele_scene)
	if throwable_scene:
		change_throwable(throwable_scene,remain_throwable)
func _input(event: InputEvent) -> void:
	if meele_weapon:
		if (event.is_action_pressed("meele")):
			if meele_weapon:
				
				meele_weapon.melee_attack()
	if gun_weapon:
		if event.is_action_pressed("attack"):
			gun_weapon.trigger_on()
		
		elif event.is_action_released("attack"):
			gun_weapon.trigger_off()
		elif event.is_action_pressed("change_fire_mode"):
			gun_weapon.change_fire_mode()
		elif event.is_action_pressed("reload_magezine"):
			gun_weapon._full_magezine_test()
	
	if event.is_action_pressed("throw") and remain_throwable>0:
		throw_throwable()
		
	#if (gun_weapon and event.is_action_pressed("attack")):
		#print(gun_weapon.position)
		#gun_weapon.shoot_bullet()
func throw_throwable():
	var mouse_position=get_global_mouse_position()
	var throwable_entity=throwable_scene.instantiate()
	throwable_entity.target_global_position=mouse_position
	throwable_entity.global_position=global_position
	get_parent().get_parent().add_child(throwable_entity)
	throwable_entity.global_position=global_position
	remain_throwable-=1
func change_throwable(throwable:PackedScene,remain_count):
	if remain_count<=0:
		return
	throwable_scene=throwable
	remain_throwable=remain_count
	
func change_weapon(weapon:PackedScene):
	 
	var weapon_scene= weapon.instantiate()
	if weapon_scene is WeaponGun:
		
		if gun_weapon:
			
			gun_weapon.queue_free()
		gun_weapon=weapon_scene as WeaponGun
		gun.add_child(weapon_scene)
	elif  weapon_scene is WeaponMelee:
		if meele_weapon:
			meele_weapon.queue_free()
		meele_weapon=weapon_scene as WeaponMelee
		meele.add_child(weapon_scene)
		meele_weapon.meele_attack_started.connect(on_meele_start)
		meele_weapon.meele_attack_finished.connect(on_meele_end)
		
func on_meele_start():
	if gun_weapon:
		gun_weapon.hit_enable=false
func on_meele_end():
	if gun_weapon:
		gun_weapon.hit_enable=true	
func get_mouse_direction():
	return (get_global_mouse_position() - global_position).normalized()
func _physics_process(delta: float) -> void:
	direction = get_mouse_direction()
	rotation=direction.angle()
	
	pass
