extends MarginContainer

var brick_scn = preload("res://Brick.tscn")
var ball_scn = preload("res://Ball.tscn")

func _ready():
	init()

func init():
	for x in range(1, 20):
		for y in range(1, 10):
			add_child(_spawn_brick(x * 90, 50 + y * 25))
	
	var player = find_node("PlayerPaddle")
	var player_pos = player.position
	var ball = _spawn_ball(player_pos.x, player_pos.y - 24)
	player.attachedBalls.append(ball)
	add_child(ball)
	
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

func ball_lost(_ball):
	_reset_ball()

func _on_WallBottom_body_entered(body):
	ball_lost(body)
