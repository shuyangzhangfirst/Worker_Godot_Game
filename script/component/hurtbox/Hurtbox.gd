class_name Hurtbox extends Area2D

signal TakeDamage(hitbox:Hitbox)
@export var can_be_invincible:bool = true
@export var invulnerable_duration:float=1
var collision_shape:CollisionShape2D
var invulnerable:bool = false

func _ready() -> void:
	area_entered.connect(OnAreaEntered)
	for c in get_children():
		if c is CollisionShape2D:
			collision_shape=c
	if get_parent().has_method("TakeDamage"):
		TakeDamage.connect(Callable(get_parent(), "TakeDamage"))
	
	
func enable_hurtbox(enable):
	collision_shape.disabled= !enable 		
		
func OnAreaEntered(area:Area2D):
	
	if can_be_invincible and invulnerable:
		
		return 
	
	elif area is Hitbox:
		
		TakeDamage.emit(area)
		invulnerable=true
		await get_tree().create_timer(invulnerable_duration).timeout
		invulnerable=false
		
	
func _connec_signals() -> void:
	var node: Node2D = get_parent()
	if node.has_method("TakeDamage"):
		area_entered.connect(node.TakeDamage)
	area_entered.connect(OnAreaEntered)
