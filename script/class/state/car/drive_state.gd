extends CarState
class_name DriveState


	
func Physic(_delta:float):
	car.input_direction=Vector2(
	Input.get_axis("Left", "Right"),
	Input.get_axis("Up", "Down")
	)
	
	
	var v =car.get_move_vector(_delta)
	car.velocity=v
	car.animated_sprite_2d.play(car.match_animation_direction(car.move_direction))
	car.update_collision_direction()
	car.move_and_slide()
	
