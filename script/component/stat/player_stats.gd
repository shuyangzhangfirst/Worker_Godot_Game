class_name PlayerStats extends Resource


@export var strength:int #决定近战攻击力 负重
@export var vitality:int #决定生命值 各种抗性
@export var stamina:int ##决定耐力 负重
@export var luck:int ## 决定宝箱物品掉率，暴击率

var _hp:=0
var current_hp:
	get:
		return _hp
	set(value):
		_hp=value

var max_hp:
	get :
		return vitality*10
	

#func _init(_strength,_vitality,_stamina,_luck) -> void:
	#self.strength=_strength
	#self.vitality=_vitality
	#self.stamina=_stamina
	#self.luck=_luck
	#self.current_hp=max_hp
