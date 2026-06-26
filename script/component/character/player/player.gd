class_name Player extends Character

signal drive_car




@export var hurtbox:Hurtbox
@export var stats:PlayerStats
@export var current_weapon:Weapon
var player_collision_shape:CollisionShape2D

var camera:Camera2D
func _ready() -> void:
	super._ready()
	for c in get_children():
		if c is CollisionShape2D:
			player_collision_shape=c
		elif c is Camera2D:
			camera=c
	GameSystem.data.current_player=self
	
func _physics_process(_delta: float) -> void:
	move_direction=Vector2(
	Input.get_axis("Left", "Right"),
	Input.get_axis("Up", "Down")
	)

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("shoot"):
		#gun._shoot_bullet()
		


	
func TakeDamage(hitbox:Hitbox):
	stats.current_hp-=hitbox.calculate_damage(self)
	effect_animation_player.play("takedamage")
	print(stats.max_hp)
	
	
func disable_player():
	hurtbox.enable_hurtbox(false)
	player_collision_shape.disabled=true
	process_mode=Node.PROCESS_MODE_DISABLED
	visible=false
	camera.enabled=false
func enable_player():
	hurtbox.enable_hurtbox(true)
	player_collision_shape.disabled=false
	process_mode=Node.PROCESS_MODE_INHERIT
	visible=true
	camera.enabled=true

	
	


	


	
	
