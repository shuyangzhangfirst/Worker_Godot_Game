extends MarginContainer

signal change_settings

@onready var master_volume_slider: VolumeSlider = %MasterVolumeSlider
@onready var bgm_volume_slider: VolumeSlider = %BgmVolumeSlider
@onready var sfx_volume_slider: VolumeSlider = %SfxVolumeSlider
@onready var env_volume_slider: VolumeSlider = %EnvVolumeSlider
@onready var eff_volume_slider: VolumeSlider = %EffVolumeSlider

func _ready() -> void:
	_connect_signal()

func change_settings_signal() -> void:
	change_settings.emit()

func update() -> void:
	master_volume_slider.update_vloume_slider()
	bgm_volume_slider.update_vloume_slider()
	sfx_volume_slider.update_vloume_slider()
	env_volume_slider.update_vloume_slider()
	eff_volume_slider.update_vloume_slider()

func _connect_signal() -> void:
	master_volume_slider.change.connect(change_settings_signal)
	bgm_volume_slider.change.connect(change_settings_signal)
	sfx_volume_slider.change.connect(change_settings_signal)
	env_volume_slider.change.connect(change_settings_signal)
	eff_volume_slider.change.connect(change_settings_signal)
