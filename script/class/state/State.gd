class_name State extends Node

@export var state_id:StateConstands.State 
@export var state_name:String
var statemachine:StateMachine
var character:Character
func _ready() -> void:
	process_mode=Node.PROCESS_MODE_DISABLED

func Init():
	pass
func Enter_With_Parameter(para:Array):
	process_mode=Node.PROCESS_MODE_INHERIT
	pass

func Enter():
	process_mode=Node.PROCESS_MODE_INHERIT
	pass
func Exit():
	process_mode=Node.PROCESS_MODE_DISABLED
	pass

func Physic(_delta:float):
	
	pass

func Process(_delta:float):
	pass
	
	
func HandleInput(_input:InputEvent):
	pass
