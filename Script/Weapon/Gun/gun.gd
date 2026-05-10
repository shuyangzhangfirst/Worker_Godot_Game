class_name Gun extends Sprite2D

@onready var marker_2d: Marker2D = $Marker2D

@export var bullet:PackedScene
func _ready() -> void:
	look_at(get_global_mouse_position())
	pass

func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())
	pass

func shoot():
	var newbullet:Area2D = bullet.instantiate() 
	newbullet.global_position=marker_2d.global_position
	newbullet.rotation = self.rotation
	GlobalInstance.main.add_child(newbullet)
	
