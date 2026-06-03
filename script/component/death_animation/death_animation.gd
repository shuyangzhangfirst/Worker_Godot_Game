extends Node2D
class_name DeathAnimation

@export var corpse_fragment_scene: PackedScene

@export var corpse_fragment_texture: Array[Texture2D]	## 尸体残骸

@export var particle_effect: GPUParticles2D	## 可选：粒子特效（血迹/烟雾）

@export var fragment_count: int = 6	## 尸体残骸数量

@export var explosion_force: float = 100.0	## 爆炸冲击力

@export var force_randomness: float = 0.5	## 力度随机性

var _corpse_fragment_pool: Array[CorpseFragment]


func _ready() -> void:
	_init_corpse_fragment()

## 播放死亡动画
func play_death_effect(_position: Vector2 = global_position, impact_direction: Vector2 = Vector2.UP) -> void:
	_spawn_corpse_fragments(_position, impact_direction)
	_play_particle_effect(_position)

## 生成尸体残骸
func _spawn_corpse_fragments(_position: Vector2, impact_direction: Vector2) -> void:
	if _corpse_fragment_pool.is_empty():
		push_warning("没有可用的尸体残骸！")
		return
	
	for corpse_fragment in _corpse_fragment_pool:
		# 显示并设置位置
		corpse_fragment.visible = true
		var spawn_pos: Vector2 = _position + Vector2(randf_range(-10, 10), randf_range(-10, 10))
		corpse_fragment.global_position = spawn_pos
		
		# 重置物理状态
		corpse_fragment.linear_velocity = Vector2.ZERO
		corpse_fragment.angular_velocity = 0.0
		corpse_fragment.sleeping = false
		
		# 计算随机飞散方向
		var random_dir: Vector2 = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		var force_magnitude: float = explosion_force * (1.0 + randf_range(-force_randomness, force_randomness))
		var final_force: Vector2 = (impact_direction + random_dir).normalized() * force_magnitude
		
		# 施加冲击力
		corpse_fragment.apply_central_impulse(final_force)
		
		# 施加随机旋转
		var random_torque: float = randf_range(-50, 50)
		corpse_fragment.apply_torque_impulse(random_torque)

## 播放粒子特效
func _play_particle_effect(_position: Vector2) -> void:
	if particle_effect:
		var particle_instance: GPUParticles2D = particle_effect.duplicate()
		particle_instance.global_position = _position
		get_parent().add_child(particle_instance)
		particle_instance.emitting = true
		
		# 粒子播放完成后自动销毁
		await get_tree().create_timer(particle_instance.lifetime).timeout
		particle_instance.queue_free()

## 初始化尸体残骸
func _init_corpse_fragment() -> void:
	if corpse_fragment_texture.is_empty():
		push_warning("没有设置尸体碎片纹理！")
		return
	
	for i in range(min(fragment_count, corpse_fragment_texture.size())):
		var new_corpse_fragment: CorpseFragment = corpse_fragment_scene.instantiate()
		new_corpse_fragment.name = "尸体残骸" + "[" + str(i) + "]"

		add_child(new_corpse_fragment)
		
		# 设置纹理
		if new_corpse_fragment.sprite_2d:
			new_corpse_fragment.sprite_2d.texture = corpse_fragment_texture[i]
		
		new_corpse_fragment.visible = false
		_corpse_fragment_pool.append(new_corpse_fragment)
