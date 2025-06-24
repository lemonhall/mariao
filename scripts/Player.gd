extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -600.0

# 获取重力值
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# 玩家状态
var is_dead = false

func _physics_process(delta):
	# 如果玩家死亡，执行死亡物理
	if is_dead:
		_death_physics(delta)
		return
	
	# 正常游戏物理
	_normal_physics(delta)

func _normal_physics(delta):
	# 添加重力
	if not is_on_floor():
		velocity.y += gravity * delta

	# 处理跳跃
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		# 播放跳跃音效
		$JumpAudio.play()

	# 处理左右移动
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# 处理精灵翻转
	if direction > 0:
		$Sprite2D.flip_h = false
	elif direction < 0:
		$Sprite2D.flip_h = true

func _death_physics(delta):
	# 死亡时只受重力影响，不能移动
	velocity.y += gravity * delta
	move_and_slide()

# 玩家死亡函数
func die():
	if is_dead:
		return  # 防止重复死亡
	
	print("玩家死亡！播放死亡动画")
	is_dead = true
	
	# 播放死亡音效
	$DeathAudio.play()
	
	# 死亡动画：向上飞起
	velocity.x = 0
	velocity.y = -500
	
	# 改变玩家颜色表示死亡状态
	$Sprite2D.modulate = Color(0.5, 0.5, 0.5, 1)  # 灰色
	
	# 2秒后处理死亡逻辑
	await get_tree().create_timer(2.0).timeout
	_handle_death()

func _handle_death():
	var game_manager = get_node("/root/GameManager")
	if game_manager:
		game_manager.lose_life()
	
	# 如果还有生命，重新开始关卡；否则GameManager会处理游戏结束
	if game_manager and game_manager.lives > 0:
		print("重新开始关卡")
		get_tree().reload_current_scene()

# 重置玩家状态（用于关卡重新开始）
func reset():
	is_dead = false
	velocity = Vector2.ZERO
	$Sprite2D.modulate = Color(1, 1, 1, 1)  # 恢复正常颜色 