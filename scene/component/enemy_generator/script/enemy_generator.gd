@tool
extends Node2D
class_name EnemyGenerator



@export var min_spawn_distance:Vector2 : set = set_min ##敌人生成的最短矩形面积
@export var max_spawn_distance:Vector2 : set = set_max ##敌人生成的最长矩形面积
@export var spawn_interval:float = 1 ##敌人生成的时间间隔 表示秒 
@export var enemies:Array[PackedScene] ##敌人生成种类
@export var tilemap:TileMapLayer : set = set_tilemap
@export var map:BaseMap : set = set_map 

@onready var min_area: CollisionShape2D = $min_area
@onready var max_area: CollisionShape2D = $max_area
@onready var timer: Timer = $Timer

var tile_size:Vector2=Vector2(32,32)
var spawn_tiles_position:Array[Vector2i] ##可生成敌人tile区域
var real_spawn_tiles_position:Array##真正进入地图时可生成敌人区域



func set_map(v:BaseMap):
	map=v
	tilemap=map.tilemap

func set_tilemap(v:TileMapLayer):
	tile_size=v.tile_set.tile_size
	tilemap=v
	
func set_min(v):
	
	min_spawn_distance=v
	calculate_spawn_area()
	if Engine.is_editor_hint():
		min_area.shape.size =v
		queue_redraw()
func set_max(v):
	
		
	max_spawn_distance=v
	calculate_spawn_area()
	if Engine.is_editor_hint():
		max_area.shape.size=v
		queue_redraw()
	
	

func get_real_spawn_tiles_position():
	if tilemap ==null:
		return []
	var tile_pos = tilemap.local_to_map(tilemap.to_local(global_position))
	var real_tiles_position=[]
	
	for index in spawn_tiles_position:
		
		var tile_index=tile_pos+Vector2i(index.x,index.y)
		
		if is_valid_tile(tile_index):
			real_tiles_position.append(index)
	return real_tiles_position
func is_valid_tile(cell: Vector2i) -> bool:
	var source_id = tilemap.get_cell_source_id(cell)

	# 1. tile 必须存在
	if source_id == -1:
		return false

	return true
func calculate_spawn_area():
	
	if max_spawn_distance.x<= min_spawn_distance.x or max_spawn_distance.y <= min_spawn_distance.y:
		return
	
	if tile_size == null:
		return
	var max_tile_height=int(ceil(max_spawn_distance.y / tile_size.y))
	max_tile_height = max_tile_height + max_tile_height%2
	var max_tile_width=int(ceil(max_spawn_distance.x / tile_size.x))
	max_tile_width = max_tile_width+max_tile_width%2
	var min_tile_height=int(ceil(min_spawn_distance.y / tile_size.y))
	min_tile_height = min_tile_height + min_tile_height%2
	var min_tile_width=int(ceil(min_spawn_distance.x / tile_size.x))
	min_tile_width = min_tile_width+min_tile_width%2
	var min_tile_x_position=min_tile_width/2
	var min_tile_y_position=min_tile_height/2
	spawn_tiles_position=[]
	
	
	for y in range(max_tile_height):
		var current_position_y = y-(max_tile_height/2)
		var rela_y= current_position_y if current_position_y<0 else current_position_y+1
		for x in range(max_tile_width):
			
			var current_position_x = x-(max_tile_width/2)
			var rela_x=current_position_x if current_position_x<0 else current_position_x+1
			
			if abs(rela_x) <=min_tile_x_position and abs(rela_y) <= min_tile_y_position:
				
				continue
			
			spawn_tiles_position.append(Vector2i(current_position_x,current_position_y))
	

func draw_single_tile(tile_position:Vector2):
	var world_pos = tile_position * tile_size
	
	
	draw_rect(
		Rect2(world_pos,tile_size),
		Color(1,0,0,0.5),
		true
		
	)
func _draw() -> void:
	if tilemap:
		
		if real_spawn_tiles_position:
				
			for cell_pos in real_spawn_tiles_position:
					
				draw_single_tile(cell_pos)
	

func _enter_tree() -> void:
	if Engine.is_editor_hint():
		set_notify_transform(true)
func _notification(what: int) -> void:
	if what  == NOTIFICATION_TRANSFORM_CHANGED:
		
		real_spawn_tiles_position=get_real_spawn_tiles_position()
		
		if real_spawn_tiles_position:
			queue_redraw()
			
		
func _ready() -> void:
	
	if Engine.is_editor_hint():
		if tilemap:
			calculate_spawn_area()
			real_spawn_tiles_position=get_real_spawn_tiles_position()
		
			if real_spawn_tiles_position:
				queue_redraw()
			
		return 
	
	timer.timeout.connect(spawn_enemy)
	timer.wait_time=spawn_interval
	timer.start()

func spawn_enemy():
	
	if enemies.size() == 0:
		return
	if real_spawn_tiles_position.size()==0:
		return
	
	var enemy_index = randi_range(0,enemies.size()-1)
	var new_enemy = enemies[enemy_index].instantiate() as Enemy
	
	var tile_location=randi_range(0,real_spawn_tiles_position.size()-1)
	var spawn_position = real_spawn_tiles_position[tile_location]
	
	new_enemy.position.x = spawn_position.x*tile_size.x
	new_enemy.position.y = spawn_position.y * tile_size.y
	add_child(new_enemy)
	timer.start()
	
		
	
	
