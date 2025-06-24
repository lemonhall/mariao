extends CharacterBody2D

const SPEED = 50.0
var direction = -1
var has_hurt_player = false  # 防止重复伤害

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	# 连接三个碰撞区域的信号
	$LeftArea.body_entered.connect(_on_left_collision)
	$RightArea.body_entered.connect(_on_right_collision)
	$TopArea.body_entered.connect(_on_top_collision)
	print("敌人已准备好，位置：", global_position)

func _physics_process(delta):
	# 添加重力
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# 左右移动
	velocity.x = direction * SPEED
	
	# 如果碰到墙壁或到达平台边缘，转向
	if is_on_wall():
		direction *= -1
	
	move_and_slide()

# 左侧碰撞 - 玩家受伤
func _on_left_collision(body):
	if body.name == "Player" and not has_hurt_player:
		print("玩家从左侧碰到敌人！")
		_hurt_player(body)

# 右侧碰撞 - 玩家受伤
func _on_right_collision(body):
	if body.name == "Player" and not has_hurt_player:
		print("玩家从右侧碰到敌人！")
		_hurt_player(body)

# 上方碰撞 - 敌人被踩死
func _on_top_collision(body):
	if body.name == "Player":
		print("玩家踩死了敌人！")
		# 敌人被消灭，玩家获得分数和反弹
		var game_manager = get_node("/root/GameManager")
		if game_manager:
			game_manager.add_score(100)
		
		# 给玩家一个反弹效果
		body.velocity.y = -300
		
		# 销毁敌人
		queue_free()

# 伤害玩家的函数
func _hurt_player(player_body):
	print("玩家受伤！开始死亡动画")
	has_hurt_player = true
	
	# 调用玩家的死亡函数
	if player_body.has_method("die"):
		player_body.die()
