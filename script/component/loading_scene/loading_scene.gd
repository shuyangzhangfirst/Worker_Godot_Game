extends CanvasLayer
class_name LoadingScene

signal loading_scene_ready	## 加载场景就绪

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var loading_container: VBoxContainer = %LoadingContainer
@onready var timer: Timer = %Timer
@onready var loading_progress_bar: ProgressBar = %LoadingProgressBar
@onready var loading_number: Label = %LoadingNumber
@onready var label_animation: Label = %LabelAnimation

var point_index: int = 0
var point_string: Array[String] = [
	".     ",
	"..    ",
	"...   ",
	"....  ",
	"..... ",
	"......"
]

func _ready() -> void:
	await animation_player.animation_finished
	_show_loading_progress()
	await get_tree().create_timer(0.2).timeout
	loading_scene_ready.emit()

func _physics_process(_delta: float) -> void:
	if timer.is_stopped():
		_update_point_ani()
		timer.start()

## 改变进度
func _on_progress_changed(new_value: float) -> void:
	var value: int = int(new_value * 100)
	loading_number.text = str(value)
	loading_progress_bar.value = value

## 加载完成后渐出释放加载界面
func _on_load_finished() -> void:
	await get_tree().create_timer(1).timeout
	loading_container.visible = false
	animation_player.play_backwards("transition")
	await animation_player.animation_finished
	print("加载界面完成")
	queue_free()

## 开启加载进度条
func _show_loading_progress() -> void:
	loading_number.text = "0"
	loading_progress_bar.value = 0
	loading_container.visible = true
	
func _update_point_ani() -> void:
	label_animation.text = point_string[point_index]
	point_index = wrapi(point_index + 1, 0, point_string.size())
