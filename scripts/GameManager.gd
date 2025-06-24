extends Node

var score = 0
var lives = 3

signal score_changed(new_score)
signal lives_changed(new_lives)

func _ready():
	# 将游戏管理器设为自动加载单例
	pass

func add_score(points):
	score += points
	score_changed.emit(score)
	print("分数: ", score)

func lose_life():
	lives -= 1
	lives_changed.emit(lives)
	print("生命减1，剩余生命: ", lives)
	
	if lives <= 0:
		print("所有生命用尽！")
		# 延迟一下再游戏结束，让死亡动画播放完
		await get_tree().create_timer(1.0).timeout
		game_over()

func game_over():
	print("游戏结束！最终分数: ", score)
	# 重置游戏状态
	reset_game()
	get_tree().reload_current_scene()

func reset_game():
	score = 0
	lives = 3
	score_changed.emit(score)
	lives_changed.emit(lives)
	print("游戏重置") 