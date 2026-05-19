extends CanvasLayer
class_name SceneTransition

@onready var color_rect: ColorRect = %ColorRect
@onready var progress_number: Label = %ProgressNumber
@onready var loading_animation_label: Label = %LoadingAnimationLabel
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var loading_ani_timer: Timer = $LoadingAniTimer
@onready var loading_container: VBoxContainer = %LoadingContainer

@export var fade_in_time: float = 0.5	## 渐进时间
@export var fade_out_time: float = 0.5	## 渐出时间

var current_loading_path: String			## 当前加载资源路径
var loading_animation_index: int = 0
var loading_progress_array: Array[float]
var current_state: TransitionState = TransitionState.NONE
## 加载中动画字符串
var _label_string: Array[String] = [
	".     ",
	"..    ",
	"...   ",
	"....  ",
	"..... ",
	"......",
]

enum TransitionState {
	NONE,		# 无转场
	FADE_IN,	# 正在淡入
	FADE_OUT,	# 正在淡出
	LOADING		# 正在加载
}

func _ready() -> void:
	color_rect.color.a = 0.0
	#visible = false
	
func _process(_delta: float) -> void:
	if current_state == TransitionState.LOADING:
		_update_loading_progress()  # 只在加载时更新进度
	_update_loading_ani()

func fade_in(loading_path: String = "") -> void:
	current_state = TransitionState.FADE_IN
	
	# 渐入前初始化
	color_rect.color.a = 0.0
	visible = true
	
	# 进行背景渐入
	var tween = create_tween()
	tween.set_parallel(false)
	tween.tween_property(color_rect, "color:a", 1.0, fade_in_time)
	await tween.finished
	
	# 释放tween
	tween.kill()
	tween = null

## 进入加载流程
func loading(path: String) -> void:
	current_state = TransitionState.LOADING
	
	
	current_loading_path = path
	if current_loading_path != "":
		loading_container.visible = true
		set_process(true)
	else:
		loading_container.visible = false
		set_process(false)
		
	# 初始化进度条
	progress_bar.value = 0.0
	progress_number.text = "0"
	
	# 发射加载页面完成信号
	EventBus.scene_transition_loading_state_ready.emit()

## 有加载状态进入渐出状态
func fade_out() -> void:
	if not current_state == TransitionState.LOADING:
		return
	current_state = TransitionState.FADE_OUT
	
	# 初始化可见度
	color_rect.color.a = 1.0
	visible = true
	loading_container.visible = false
	
	# 进行背景渐出
	var tween = create_tween()
	tween.set_parallel(false)
	tween.tween_property(color_rect, "color:a", 0.0, fade_out_time)
	await tween.finished
	visible = false
	current_state = TransitionState.NONE
	# 释放tween
	tween.kill()
	tween = null

## 更新加载动画
func _update_loading_ani() -> void:
	if loading_ani_timer.is_stopped():
		loading_animation_index = wrapi(loading_animation_index + 1, 0, 6)
		loading_animation_label.text = _label_string[loading_animation_index]
		loading_ani_timer.start()

## 更新加载进度条
func _update_loading_progress() -> void:
	if current_loading_path != "" or not current_loading_path:
		loading_container.visible = false
		set_process(false)
		return
	loading_container.visible = true
	ResourceLoader.load_threaded_get_status(current_loading_path, loading_progress_array)
	progress_number.text = str(loading_progress_array[0] * 100)
	
