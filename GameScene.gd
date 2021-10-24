extends MarginContainer

var brick_scn = preload("res://Brick.tscn")
var ball_scn = preload("res://Ball.tscn")
onready var score_label = $LevelBox/ScoreLabel

func _ready():
	init()

func init():
	randomize()
	_init_level()
	
	var player = find_node("PlayerPaddle")
	var player_pos = player.position
	var ball = _spawn_ball(player_pos.x, player_pos.y - 24)
	player.attachedBalls.append(ball)
	add_child(ball)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
func _init_level():
	var spacing = 4
	var brick_width = 32
	var brick_height = 16
	var scene_size = get_viewport_rect().size
	
	var x_step = brick_width + spacing
	var y_step = brick_height + spacing
	var x_bricks = int(scene_size.x / x_step)
	var y_bricks = int(scene_size.y / y_step / 3)
	var x_offset = (scene_size.x - x_bricks * x_step) / 2
	var y_offset = 32
	var seed_row = _generate_first_cellular_row(x_bricks)
	var r_colors = _seed_cellular_matrix(seed_row, y_bricks, 105)
	var g_colors = _seed_cellular_matrix(seed_row, y_bricks, 3)
	var b_colors = _seed_cellular_matrix(seed_row, y_bricks, 90)
	for y in range(1, y_bricks):
		for x in range(1, x_bricks):
			var brick = _spawn_brick(x_offset + x * x_step, y_offset + y * y_step)
			var r = float(0.5 + 0.5 * r_colors[y][x])
			var g = float(0.5 + 0.5 * g_colors[y][x])
			var b = float(0.5 + 0.5 * b_colors[y][x])
			brick.set_color(Color(r, g, b))
			add_child(brick)
			
func _generate_first_cellular_row(num_cols) -> Array:
	var first_row = []
	for _x in range(0, num_cols):
		first_row.append(randi() % 2)
	return first_row
	
func _seed_cellular_matrix(seed_row, num_rows, rule):
	var rows = [seed_row]
	var num_cols = seed_row.size()
	for _y in range(1, num_rows):
		var row = []
		var prev_row = rows[-1]
		for x in range(0, num_cols):
			row.append(decode_rule(rule, prev_row[x - 1], prev_row[x], prev_row[(x + 1) % prev_row.size()]))
		rows.append(row)
	return rows

func decode_rule(rule, input_bit_1, input_bit_2, input_bit_3) -> int:
	# rule must be [0..256], input bits [0..1]
	var position = (input_bit_1 << 2) + (input_bit_2 << 1) + input_bit_3
	return (rule >> position) & 1
		
	
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
