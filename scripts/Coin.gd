extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)
	# 添加旋转动画
	_start_rotation_animation()

func _start_rotation_animation():
	# 创建一个Tween来制作旋转动画
	var tween = create_tween()
	tween.set_loops()  # 无限循环
	tween.tween_property($Sprite2D, "rotation", TAU, 2.0)  # 2秒转一圈

func _on_body_entered(body):
	if body.name == "Player":
		# 播放金币收集音效
		$CoinAudio.play()
		
		# 增加分数
		var game_manager = get_node("/root/GameManager")
		if game_manager:
			game_manager.add_score(10)
		else:
			print("金币已收集！获得10分")
		
		# 隐藏精灵和碰撞，但保留节点让音效播放完
		$Sprite2D.visible = false
		$CollisionShape2D.disabled = true
		
		# 等待音效播放完毕再销毁金币
		await $CoinAudio.finished
		queue_free() 