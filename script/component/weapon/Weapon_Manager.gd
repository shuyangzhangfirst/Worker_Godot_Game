extends Node2D
class_name  WeaponManager

enum Hands{
	left,
	right,
	both
}
@export var left_hand_scene:PackedScene
@export var right_hand_scene:PackedScene
@onready var left_hand: Node2D = $LeftHand
@onready var right_hand: Node2D = $RightHand

var direction:Vector2
var left_hand_weapon:Weapon
var right_hand_weapon:Weapon

func hit_enable(enable:bool,hands:Hands):
	if hands==Hands.left:
		if left_hand_weapon:
			left_hand_weapon.hit_enable=enable
	elif hands == Hands.right:
		if right_hand_weapon:
			right_hand_weapon.hit_enable=enable
	elif hands == Hands.both:
		if left_hand_weapon and right_hand_weapon:
			left_hand_weapon.hit_enable=enable
			right_hand_weapon.hit_enable=enable
	else:
		return 
func change_weapon(hand:Hands,weapon_scene:PackedScene):
	if weapon_scene==null:
		return
	if hand == Hands.left:
		left_hand_scene=weapon_scene
		if left_hand_weapon:
			left_hand_weapon.queue_free()
		left_hand_weapon = left_hand_scene.instantiate() as Weapon
		left_hand.add_child(left_hand_weapon)
	elif hand == Hands.right:
		right_hand_scene=weapon_scene
		if right_hand_weapon:
			right_hand_weapon.queue_free()
		right_hand_weapon = right_hand_scene.instantiate() as Weapon
		right_hand.add_child(right_hand_weapon)
	else:
		return
func set_weapons_direction_and_rotation():
	var mouse_position=get_global_mouse_position()
	direction = global_position.direction_to(mouse_position)
	rotation = direction.angle()
	if left_hand_weapon and left_hand_weapon is Gun:
		left_hand_weapon.gun_direction=direction
	if right_hand_weapon and right_hand_weapon is Gun:
		right_hand_weapon.gun_direction=direction
	pass
	
func _physics_process(delta: float) -> void:
	set_weapons_direction_and_rotation()
	pass
func _ready() -> void:
	change_weapon(Hands.left,left_hand_scene)
	change_weapon(Hands.right,right_hand_scene)
