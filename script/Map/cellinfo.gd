
class_name CellInfo

enum direction{
	up,
	down,
	right,
	left
}
var availabledirection:Dictionary[direction,bool]

func _init(up,down,right,left) -> void:
	if up:
		self.availabledirection[direction.up]=true
	if down:
		self.availabledirection[direction.down]=true
	if right:
		self.availabledirection[direction.right]=true
	if left:
		self.availabledirection[direction.left]=true


	
	
