extends MarginContainer

var brick_scn = preload("res://Brick.tscn")
var ball_scn = preload("res://Ball.tscn")
onready var score_label = $HBoxContainer/HudBox/ScoreLabel

func _ready():
	init()

func init():
	_init_level()
	
	var player = find_node("PlayerPaddle")
	var player_pos = player.position
	var ball = _spawn_ball(player_pos.x, player_pos.y - 24)
	player.attachedBalls.append(ball)
	add_child(ball)
	
func _init_level():
	var spacing = 2
	var brick_width = 32
	var brick_height = 16
	var scene_size = get_viewport_rect().size
	
	var x_step = brick_width + spacing
	var y_step = brick_height + spacing
	var x_bricks = int(scene_size.x / x_step)
	var y_bricks = int(scene_size.y / y_step / 3)
	var x_offset = (scene_size.x - x_bricks * x_step) / 2
	var y_offset = 16
	for x in range(1, x_bricks):
		for y in range(1, y_bricks):
			add_child(_spawn_brick(x_offset + x * x_step, y_offset + y * y_step))
	
func _reset_ball():
	var player = find_node("PlayerPaddle")
	var player_pos = player.position
	var ball = _spawn_ball(player_pos.x, player_pos.y - 24)
	player.attachedBalls.append(ball)
	call_deferred("add_child", ball)

func _spawn_brick(x, y):
	var new_brick = brick_scn.instance()
	new_brick.set_position(Vector2(x, y))
	new_brick.add_to_group("bricks")
	return new_brick

func _spawn_ball(x, y):
	var new_ball = ball_scn.instance()
	new_ball.position = Vector2(x, y)
	new_ball.add_to_group("balls")
	return new_ball
	
func _process(delta):
	score_label.text = "Score: " + str(find_node("PlayerPaddle").score)

func ball_lost(_ball):
	_reset_ball()

func _on_WallBottom_body_entered(body):
	ball_lost(body)
