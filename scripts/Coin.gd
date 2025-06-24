extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player":
		# 增加分数
		var game_manager = get_node("/root/GameManager")
		if game_manager:
			game_manager.add_score(10)
		else:
			print("金币已收集！获得10分")
		queue_free() 