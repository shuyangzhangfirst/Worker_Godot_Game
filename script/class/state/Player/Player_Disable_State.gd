extends PlayerState
class_name DisableState

func Enter():
	character.disable_player()

func Exit():
	character.enable_player()
	
