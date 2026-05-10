class_name Player extends Character

@export var gun:Gun
func _ready() -> void:
	statemachine.Initialize(self)
	GlobalInstance.player = self
func _physics_process(_delta: float) -> void:
	move_direction=Vector2(
	Input.get_axis("Left", "Right"),
	Input.get_axis("Up", "Down")
	)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		gun.shoot()
		


	
	
	



	
	


	


	
	
