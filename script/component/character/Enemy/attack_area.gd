extends Area2D
class_name AttackArea
signal attack_area_entered(character:Character)

func _ready() -> void:
	body_entered.connect(on_area_entered)

func on_area_entered(body):
	attack_area_entered.emit(body)
