extends CarState
class_name DriveState
@onready var camera_2d: Camera2D = $"../../Camera2D"

func Enter():
	camera_2d.enabled=true
	
func Exit():
	camera_2d.enabled=false
	
func Physic(_delta:float):
	car.input_direction=Vector2(
	Input.get_axis("Left", "Right"),
	Input.get_axis("Up", "Down")
	)
	
	
	var v =car.get_move_vector(_delta)
	if car.speed==0:
		car.set_collision_mask_value(3,true)
	else:
		car.set_collision_mask_value(3,false)
	car.velocity=v
	car.animated_sprite_2d.play(car.match_animation_direction(car.move_direction))
	car.update_collision_direction()
	car.update_hit_box()
	car.move_and_slide()
	
