class_name Player extends Character

func _ready() -> void:
	statemachine.Initialize(self)
func _physics_process(delta: float) -> void:
	move_direction=Vector2(
	Input.get_axis("Left", "Right"),
	Input.get_axis("Up", "Down")
	)
	
	
	



	
	


	


	
	
