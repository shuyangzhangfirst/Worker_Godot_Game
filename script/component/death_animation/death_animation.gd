extends Node2D
class_name DeathAnimation

@onready var blood_mist: GPUParticles2D = $BloodMist

func _ready() -> void:
	_init_animation()
	
func _init_animation() -> void:
	blood_mist.emitting = true
	await blood_mist.finished.connect(_queen_free)

func _queen_free() -> void:
	queue_free()
