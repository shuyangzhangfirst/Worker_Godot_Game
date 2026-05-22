@tool
extends Node

@onready var data: DataManager = %Data
@onready var audio: AudioManager = %Audio
@onready var settings: SettingsManager = %Settings
@onready var scene_load: SceneLoad = %SceneLoad

var main_scene: Node2D	## 游戏主场景
var game_wrold: GameWrold	## 游戏世界场景
