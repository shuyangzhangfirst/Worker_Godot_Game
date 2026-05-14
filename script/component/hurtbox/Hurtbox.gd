class_name Hurtbox extends Area2D

signal TakeDamage(hitbox:Hitbox)

func _ready() -> void:
	_connec_signals()
	
	

func OnAreaEntered(area:Area2D):
	if area is Hitbox:
		TakeDamage.emit(area)
		
	
func _connec_signals() -> void:
	var node: Node2D = get_parent()
	if node.has_method("TakeDamage"):
		area_entered.connect(node.TakeDamage)
	area_entered.connect(OnAreaEntered)
