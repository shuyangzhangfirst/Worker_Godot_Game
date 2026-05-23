class_name StateMachine extends Node

@export var intialize_state:State
var current_state:State
var previous_state:State
var states:Dictionary[StateConstands.State,State]



func Initialize(character:Character):
	self.states={}
	
	for state in self.get_children():
		if state is State:
			
			self.states[state.state_id]=state
			state.character = character
			state.statemachine=self
			state.Init()
	current_state=intialize_state
	
	previous_state=intialize_state
	current_state.Enter()
	
func _process(delta: float) -> void:
	current_state.Process(delta)
func _physics_process(delta: float) -> void:
	
	current_state.Physic(delta)
	
	

func SwitchState(new_state:State):
	
	
	
	previous_state=current_state
	current_state.Exit()
	current_state=new_state
	current_state.Enter()
