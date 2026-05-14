@tool
class_name MapGenerator extends Node2D

var tiledata:Dictionary={
	"grass":{
		source_id=0,
		
	}
}
@export var maxstep:int=600
@export var dimension:Vector2i = Vector2i(50,50)
@export var randomize_seed =true
@export var gen_seed=5
@export var tile_map:TileMap
@export_tool_button("GenerateMap")
var genmap := Callable(self, "GenerateMap")

func _ready() -> void:
	GenerateMap()
	
func GenerateMap():
	if randomize_seed:
		gen_seed=randi()
	seed(gen_seed)
	tile_map.clear()
	var start_point = Vector2i(
	randi_range(0, dimension.x - 1),
	randi_range(0, dimension.y - 1)
	)
	var map:Array[Array]=GenerateMapMatrix(dimension.x,dimension.y,start_point)
	var row=0
	for y in map.size():
		for x in map[y].size():
			if map[y][x] == 1:
				tile_map.set_cell(0,Vector2i(x,y),1,Vector2i(1,1))
			else :
				tile_map.set_cell(0,Vector2(x,y),2,Vector2i(0,0))
	

func GenerateMapMatrix(width:int,height:int,startpoint:Vector2i)->Array[Array]:
	var map:Array[Array]=[]
	for y in height:
		var row=[]
		for x in width:
			row.append(0)
		map.append(row)
	
	TravelNextBlock(map,startpoint,maxstep,width,height)
	return map
		
	
func TravelNextBlock(map,currentposition:Vector2i,remain_step,width,height)->int:
	if remain_step<=0:
		return remain_step
	var new_direction=[]
	
	for direction in [Vector2i.DOWN,Vector2i.LEFT,Vector2i.UP,Vector2i.RIGHT]:
		var next_position:Vector2i= currentposition+direction
		if next_position.x >= 0 \
		and next_position.y >= 0 \
		and next_position.x < width \
		and next_position.y < height \
		and map[next_position.y][next_position.x] == 0:

			new_direction.append(direction)
	
	
	while new_direction:
		var dir:Vector2i = new_direction.pick_random()
		new_direction.erase(dir)
		dir=currentposition+dir
		map[dir.y][dir.x]=1
		remain_step= TravelNextBlock(map,dir,remain_step-1,width,height)
		if remain_step <=0:
			return remain_step
	return remain_step
	
		
		
	
	
	
	
	
	
