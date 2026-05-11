class_name StatModifier extends Resource

enum OperateType{
	add,
	sub,
	mul,
	div,
	forceset
}
var type:OperateType
var value:float
func _init(_type:OperateType=OperateType.add, _value:float=0) -> void:
	self.type=_type
	self.value=_value
	

static func Sub(_value):
	return StatModifier.new(OperateType.sub,_value)


static func Add(_value):
	return StatModifier.new(OperateType.add,_value)

static func Div(_value):
	return StatModifier.new(OperateType.div,_value)

static func Mul(_value):
	return StatModifier.new(OperateType.mul,_value)
static func Set(_value):
	return StatModifier.new(OperateType.forceset,_value)

func Operatoe(base_value)->float:
	
	
	match  self.type:
		OperateType.add: return base_value+value
		OperateType.sub: return base_value-value
		OperateType.div: return base_value/value
		OperateType.mul: return base_value*value
		OperateType.forceset: return value
		_: return base_value

 
