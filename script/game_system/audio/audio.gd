extends Node
class_name AudioManager

## 是否初始化
var is_init: bool = false

@onready var music: Node = %Music
@onready var env: Node = %Env
@onready var sfx: Node = %SFX
@onready var voice: Node = %Voice


var current_music: AudioStream	## 当前播放音乐

## 背景音乐渐变时长
@export var fade_time: float = 1.0
## 渐变tween
var fade_in_tween: Tween
var fade_out_tween: Tween

## 音频Bus索引
enum BusIndex {
	Master = 0,
	Music = 1,
	SFX = 2,
	Voice = 3,
	Env = 4
}

## 音频Bus名称映射
var bus_names :={
	BusIndex.Master: "Master",
	BusIndex.Music: "Music",
	BusIndex.SFX: "SFX",
	BusIndex.Voice: "Voice",
	BusIndex.Env: "Env",
}

#region 音频初始化函数
## 初始化音频系统
func _ready() -> void:
	_init_music_audio()
	_init_sfx_audio()
	_init_voice_audio()
	_init_env_audio()
	is_init = true

#region 背景音乐初始化
## 背景音乐播放器数量
var music_player_count: int = 2
## 当前背景音乐播放器索引
var current_music_player_index = 0
## 背景音乐播放器列表
var music_players: Array[AudioStreamPlayer] = []
## 初始化背景音乐音频
func _init_music_audio() -> void:
	for i in music_player_count:
		var music_player = AudioStreamPlayer.new()
		music_player.name = "music_player_" + str(i)
		music_player.bus = bus_names[BusIndex.Music]
		music_player.process_mode = Node.PROCESS_MODE_ALWAYS
		music.add_child(music_player)
		music_players.append(music_player)
#endregion

#region 音效初始化
## 音效播放器数量
@export var SFX_player_count: int = 20
## 当前音效播放器索引
var current_SFX_player_index = 0
## 音效播放器列表
var sfx_players: Array[AudioStreamPlayer] = []
## 初始化音效音频
func _init_sfx_audio() -> void:
	for i in SFX_player_count:
		var sfx_player = AudioStreamPlayer.new()
		sfx_player.name = "sfx_player_" + str(i)
		sfx_player.bus = bus_names[BusIndex.SFX]
		sfx.add_child(sfx_player)
		sfx_players.append(sfx_player)
#endregion

#region 语音初始化
## 语音播放器数量
@export var voice_player_count: int = 1
## 当前语音播放器索引
var current_voice_player_index = 0
## 语音播放器列表
var voice_players: Array[AudioStreamPlayer] = []
## 初始化语音音频
func _init_voice_audio() -> void:
	for i in voice_player_count:
		var voice_player = AudioStreamPlayer.new()
		voice_player.name = "voice_player_" + str(i)
		voice_player.bus = bus_names[BusIndex.Voice]
		voice.add_child(voice_player)
		voice_players.append(voice_player)
#endregion

#region 环境音初始化
## 环境音效播放器数量
@export var env_player_count: int = 5
## 当前环境音效播放器索引
var current_env_player_index = 0
## 环境音效播放器列表
var env_players: Array[AudioStreamPlayer] = []
## 初始化环境音频
func _init_env_audio() -> void:
	for i in env_player_count:
		var env_player = AudioStreamPlayer.new()
		env_player.name = "env_player_" + str(i)
		env_player.bus = bus_names[BusIndex.Env]
		env_player.process_mode = Node.PROCESS_MODE_ALWAYS
		env.add_child(env_player)
		env_players.append(env_player)
#endregion

#region 音频播放调用API
## 背景音乐播放
func play_music(_audio: AudioStream, is_replay: bool = false) -> void:
	var current_audio_player := music_players[current_music_player_index]
	if current_audio_player.stream == _audio and not is_replay:
		if OS.is_debug_build():
			print("播放背景音乐")
		return
	var empty_audio_player_index = 0 if current_music_player_index == 1 else 1
	var empty_audio_player := music_players[empty_audio_player_index]
	## 渐出
	await _stop_and_fade_out(current_audio_player)
	## 渐入
	empty_audio_player.stream = _audio
	current_music = _audio
	_play_and_fade_in(empty_audio_player)
	
	current_music_player_index = empty_audio_player_index

## 音效播放
func play_sfx(_audio: AudioStream, _is_random_pitch:bool = false) -> void:
	var pitch := 1.0
	if _is_random_pitch:
		pitch = randf_range(0.9, 1.1)
	
	var is_play: bool = false
	for i in SFX_player_count:
		var sfx_audio_player := sfx_players[i]
		if not sfx_audio_player.playing:
			sfx_audio_player.stream = _audio
			sfx_audio_player.pitch_scale = pitch
			sfx_audio_player.play()
			is_play = true
			break
	# 如果没有空闲播放器，创建新的
	if not is_play:
		var new_player = AudioStreamPlayer.new()
		new_player.name = "sfx_player_%d" % sfx_players.size() + "tmp"
		new_player.bus = bus_names[BusIndex.SFX]
		new_player.finished.connect(_delete_sfx_player.bind(new_player))
		sfx.add_child(new_player)
		sfx_players.append(new_player)
		new_player.stream = _audio
		new_player.play()

## 语音播放
func play_voice(_audio: AudioStream) -> void:
	var is_play: bool = false
	for i in voice_player_count:
		var voice_audio_player := voice_players[i]
		if not voice_audio_player.playing:
			voice_audio_player.stream = _audio
			voice_audio_player.play()
			is_play = true
			break
	# 如果没有空闲播放器，创建新的
	if not is_play:
		var new_player = AudioStreamPlayer.new()
		new_player.name = "voice_player_%d" % voice_players.size()
		new_player.bus = bus_names[BusIndex.Voice]
		new_player.finished.connect(_delete_voice_player.bind(new_player))
		voice.add_child(new_player)
		voice_players.append(new_player)
		new_player.stream = _audio
		new_player.play()

## 环境音效播放
func play_env(_audio: AudioStream) -> void:
	var is_play: bool = false
	for i in env_player_count:
		var env_audio_player := env_players[i]
		if not env_audio_player.playing:
			env_audio_player.stream = _audio
			env_audio_player.play()
			is_play = true
			break
	# 如果没有空闲播放器，创建新的
	if not is_play:
		var new_player = AudioStreamPlayer.new()
		new_player.name = "env_player_%d" % env_players.size()
		new_player.bus = bus_names[BusIndex.Env]
		new_player.finished.connect(_delete_env_player.bind(new_player))
		env.add_child(new_player)
		env_players.append(new_player)
		new_player.stream = _audio
		new_player.play()
#endregion

#region 渐进渐出
## 背景音乐渐入
func _play_and_fade_in(_audio_player: AudioStreamPlayer) -> void:
	if fade_in_tween:
		fade_in_tween.kill()
	if fade_out_tween:
		fade_out_tween.kill()
	_audio_player.volume_db = -40  # 初始静音
	_audio_player.play()
	fade_in_tween = create_tween()
	fade_in_tween.tween_property(_audio_player, "volume_db", 0, fade_time)

## 背景音乐渐出
func _stop_and_fade_out(_audio_player: AudioStreamPlayer) -> void:
	if not _audio_player.playing:
		return
	fade_out_tween = create_tween()
	fade_out_tween.tween_property(_audio_player, "volume_db", -40, fade_time)
	await  fade_out_tween.finished
	_audio_player.stop()
	_audio_player.stream = null
#endregion

#region 音频节点释放
## 环境音效播放器释放
func _delete_env_player(player: AudioStreamPlayer) -> void:
	env_players.erase(player)
	player.stop()
	player.stream = null
	player.queue_free()

## 音效播放器释放
func _delete_sfx_player(player: AudioStreamPlayer) -> void:
	sfx_players.erase(player)
	player.stop()
	player.stream = null
	player.queue_free()
	
## 语音播放器释放
func _delete_voice_player(player: AudioStreamPlayer) -> void:
	voice_players.erase(player)
	player.stop()
	player.stream = null
	player.queue_free()
#endregion

## 清空所有音乐
func clear_all_audio() -> void:
	clear_music()
	clear_sfx()
	clear_voice()
	clear_env()

## 清空音乐播放器
func clear_music() -> void:
	for player in music.get_children():
		player.stream = null
	current_music = null

## 清空音效播放器的音效
func clear_sfx() -> void:
	for player in sfx.get_children():
		player.stream = null

## 清空音效播放器的音效
func clear_voice() -> void:
	for player in voice.get_children():
		player.stream = null

## 清空音效播放器的音效
func clear_env() -> void:
	for player in env.get_children():
		player.stream = null
