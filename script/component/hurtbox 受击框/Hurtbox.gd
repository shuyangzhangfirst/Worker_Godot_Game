class_name Hurtbox extends Area2D

signal TakeDamage(hitbox:Hitbox)

func _ready() -> void:
	area_entered.connect(OnAreaEntered)

func OnAreaEntered(area:Area2D):
	if area is Hitbox:
		TakeDamage.emit(area)
		
	
