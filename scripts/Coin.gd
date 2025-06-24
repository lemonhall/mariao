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
		# 增加分数
		var game_manager = get_node("/root/GameManager")
		if game_manager:
			game_manager.add_score(10)
		else:
			print("金币已收集！获得10分")
		queue_free() 