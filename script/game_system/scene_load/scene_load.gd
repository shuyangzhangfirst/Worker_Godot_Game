extends Node
class_name SceneLoad

var loading_scene: PackedScene = preload("res://scene/component/loading_scene/loading_scene.tscn")	## 加载过渡场景引用
var loaded_resource: PackedScene		## 已加载资源变量
var scene_path: String					## 场景路径
var progress: Array[float] = []			## 加载百分百进度
var use_sub_threads: bool = true		## 是否启用多线程加载

func _ready() -> void:
	set_process(false)

func _process(_delta: float) -> void:
	var load_status = ResourceLoader.load_threaded_get_status(scene_path, progress)
	
	EventBus.scene_load_progress_changes.emit(progress[0])
	
	match load_status:
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE, ResourceLoader.THREAD_LOAD_FAILED:
			push_error("加载失败")
			set_process(false)
			
		ResourceLoader.THREAD_LOAD_LOADED:
			loaded_resource = ResourceLoader.load_threaded_get(scene_path)
			EventBus.scene_load_finished.emit()
			set_process(false)

func load_scene(_scene_path: String) -> void:
	scene_path = _scene_path
	
	var new_loading_scene = loading_scene.instantiate()
	GameSystem.main_scene.add_child(new_loading_scene)
	
	EventBus.scene_load_progress_changes.connect(new_loading_scene._on_progress_changed)
	EventBus.scene_load_finished.connect(new_loading_scene._on_load_finished)
	
	await new_loading_scene.loading_scene_ready
	start_load()
	
func start_load() -> void:
	var state = ResourceLoader.load_threaded_request(scene_path, "", use_sub_threads)
	if state == OK:
		set_process(true)
