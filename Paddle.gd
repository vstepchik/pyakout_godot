extends Node2D

export var speed = 400
export var attachedBalls: Array = []

var screen_size

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	var width = $Body/CollisionShape2D.shape.height + $Body/CollisionShape2D.shape.radius * 2
	var prev_position = position
	var velocity = Vector2(0, 0)
	
	if Input.is_action_pressed("ui_select"):
		release_ball()
	
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1;
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1;
	position += velocity.normalized() * speed * delta
	position.x = clamp(position.x, width / 2, screen_size.x - width / 2)
	
	for ball in attachedBalls:
		ball.position += position - prev_position

func release_ball():
	var ball = attachedBalls.pop_back()
	if ball:
		ball.go()
		ball.apply_central_impulse(Vector2(100, -500))

func accept_score(amount):
	print("got score: ", amount)
