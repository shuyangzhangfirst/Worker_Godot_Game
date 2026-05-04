class_name State extends Node

@export var state_id:StateConstands.State 
@export var state_name:String
var statemachine:StateMachine
func _ready() -> void:
	process_mode=Node.PROCESS_MODE_DISABLED



func Enter():
	process_mode=Node.PROCESS_MODE_INHERIT
	pass
func Exit():
	process_mode=Node.PROCESS_MODE_DISABLED
	pass

func Physic(delta:float):
	
	pass

func Process(delta:float):
	pass
	
	
func HandleInput(input:InputEvent):
	pass
