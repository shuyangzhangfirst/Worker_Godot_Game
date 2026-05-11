class_name Player extends Character

@export var gun:Gun

@export var statmanager:StatsManager
@export var hurtbox:Hurtbox

func _ready() -> void:
	statemachine.Initialize(self)
	hurtbox.TakeDamage.connect(TakeDamage)

	statmanager.stats[Stat.StatType.health].ChangeBaseValue(StatModifier.Add(-1))
	print(statmanager.stats[Stat.StatType.health].GetValue())
	
func TakeDamage(hitbox:Hitbox):
	statmanager.stats[Stat.StatType.health].ChangeBaseValue(StatModifier.Add(-1))
	print(statmanager.stats[Stat.StatType.health].GetValue())

func _physics_process(_delta: float) -> void:
	move_direction=Vector2(
	Input.get_axis("Left", "Right"),
	Input.get_axis("Up", "Down")
	)

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("shoot"):
		#gun._shoot_bullet()
		


	
	
	



	
	


	


	
	
