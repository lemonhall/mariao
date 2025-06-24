extends CanvasLayer

@onready var life_label = $LifeLabel
@onready var score_label = $ScoreLabel

func _ready():
	# 连接游戏管理器的信号
	var game_manager = get_node("/root/GameManager")
	if game_manager:
		game_manager.lives_changed.connect(_on_lives_changed)
		game_manager.score_changed.connect(_on_score_changed)
		
		# 初始化显示
		_on_lives_changed(game_manager.lives)
		_on_score_changed(game_manager.score)

func _on_lives_changed(new_lives):
	life_label.text = "命: " + str(new_lives)

func _on_score_changed(new_score):
	score_label.text = "分数: " + str(new_score) 