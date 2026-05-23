class_name Player extends Character

@export var gun: Gun

@export var statmanager:StatsManager
@export var hurtbox:Hurtbox
@export var stats:PlayerStats

func _ready() -> void:
	super._ready()
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
	stats.current_hp-=hitbox.damage
	effect_animation_player.play("takedamage")
	print(stats.max_hp)
	
	



	
	


	


	
	
