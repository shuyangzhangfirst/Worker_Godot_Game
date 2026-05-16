extends Area2D
class_name ChaseArea

signal chase_area_entered(character:Character)
signal chase_area_exited(character:Character)

func _ready() -> void:
	body_entered.connect(on_area_entered)
	body_exited.connect(on_area_exited)

func on_area_entered(body:Node2D):
	
	chase_area_entered.emit(body)

func on_area_exited(body:Node2D):
	chase_area_exited.emit(body)

	
