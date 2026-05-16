@tool
extends Node

@onready var data_manager: DataManager = %DataManager
@onready var audio: AudioManager = %Audio
@onready var settings: SettingsManager = %Settings


var main_scene: Node2D	## 游戏主场景
