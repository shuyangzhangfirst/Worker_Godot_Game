extends Node
class_name StatEffect

enum effecttype{
	add_direct, #直接加数值，0.5就是加0.5，-0,5就是-0.5
	add_percent,#直接加百分比，0.5就是加50%，-0.5就是减少50%
	set_direct,#直接设置为某个数值，例如0.5
	set_percent#设置为原值的百分比
}

var type : effecttype 
var value:float
