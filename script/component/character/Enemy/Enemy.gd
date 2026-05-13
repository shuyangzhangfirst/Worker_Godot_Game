class_name Enemy extends Character

## 敌人所需要的组件
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var effect_animation_player: AnimationPlayer = $EffectAnimationPlayer


## 敌人的属性，不用如主角那样复杂，当然后面可以看吧
@export var max_hp:float  #最大生命值
@export var current_hp:float #当前生命值


func _ready() -> void:
	hurtbox.TakeDamage.connect(TakeDamage)


func TakeDamage(hitbox:Hitbox):

	
	current_hp = max(0,current_hp- hitbox.damage)
	effect_animation_player.play("takedamage")
	
	print(current_hp)
	
	hitbox.invulnerable=true
	await  get_tree().create_timer(1).timeout
	hitbox.invulnerable=false
	
