extends SubViewport


@export var camera:Camera2D
var player:Player
@export var zoom:float = 0.1
func _ready() -> void:
	world_2d=get_tree().root.world_2d
	process_mode=Node.PROCESS_MODE_DISABLED
	await get_tree().process_frame
	player=GameSystem.data.current_player
	camera.zoom = Vector2(zoom,zoom)
	process_mode=Node.PROCESS_MODE_ALWAYS

func _physics_process(delta: float) -> void:
	camera.position=player.position
