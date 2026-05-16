@tool
extends Node

@onready var data: DataManager = %Data
@onready var audio: AudioManager = %Audio
@onready var settings: SettingsManager = %Settings


var main_scene: Node2D	## 游戏主场景
