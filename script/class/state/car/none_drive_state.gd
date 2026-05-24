extends CarState
class_name NoneDriveState

@onready var playerdedectarea: Area2D = $"../../playerdedectarea"
@onready var carsymbol_player: AnimationPlayer = $"../../CarsymbolPlayer"
@onready var carsymbol: Sprite2D = $"../../Carsymbol"
@onready var camera_2d: Camera2D = $"../../Camera2D"

var player:Player
func Enter():
	camera_2d.enabled=false
	playerdedectarea.body_entered.connect(_player_entered)
	playerdedectarea.body_exited.connect(_player_leaved)

func Exit():
	playerdedectarea.body_entered.disconnect(_player_entered)
	playerdedectarea.body_exited.disconnect(_player_leaved)

func _player_entered(body):
	
	if body is Player:
		carsymbol.visible=true
		player=body
		carsymbol_player.play("player_entered")
		

func HandleInput(_input:InputEvent):
	if _input.is_action_pressed("interact") and player :

		player.drive_car.emit()
		
		statemachine.SwitchState(statemachine.states[StateConstands.State.car_drive])
		

func _player_leaved(body):
	if body is Player:
		player=null
		carsymbol.visible=false
		pass
