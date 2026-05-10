class_name PlayerShootState extends PlayerState

@export var gun:Gun

func Enter():
	gun.shoot()
	
