extends BoxContainer
class_name VolumeSlider

signal change

@export var bus_index: BusIndex = BusIndex.Master

@onready var h_slider: HSlider = %HSlider
@onready var volume_label: Label = %VolumeLabel


enum BusIndex {
	Master = 0,
	Bgm = 1,
	Sfx = 2,
	Env = 3,
	Eff = 4
}

func _ready() -> void:
	_connect_signal()
	update_vloume_slider()

## 改变音量
func change_volume(value: float) -> void:
	change.emit()
	set_volume_by_index(bus_index, value)
	_update_volume_label(value)

func _update_volume_label(value: float) -> void:
	volume_label.text = str(int(value * 100))

func update_vloume_slider() -> void:
	var value: float = GameSystem.settings.volume_setting.get_volume(bus_index)
	h_slider.set_value_no_signal(value)
	_update_volume_label(value)

func set_volume_by_index(index: int, value: float) -> void:
	match index:
		0:
			GameSystem.settings.volume_setting.master_volume = value
		1:
			GameSystem.settings.volume_setting.bgm_volume = value
		2:
			GameSystem.settings.volume_setting.sfx_volume = value
		3:
			GameSystem.settings.volume_setting.env_volume = value
		4:
			GameSystem.settings.volume_setting.eff_volume = value


func _connect_signal() -> void:
	h_slider.value_changed.connect(change_volume)
