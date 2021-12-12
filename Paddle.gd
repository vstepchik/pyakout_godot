extends Node2D

var pusher_scn = preload("res://Pusher.tscn")

export var speed = 400
export var score = 0
export var attachedBalls: Array = []
export var ball_hit_sound_paths: Array = [
	"res://res/sounds/sound_042.wav",
	"res://res/sounds/sound_043.wav",
	"res://res/sounds/sound_045.wav",
]

onready var screen_size = get_viewport_rect().size
onready var player = $Body/Sprite/BounceSoundPlayer
var ball_hit_sounds: Array = []


func _ready():
	for sound_path in ball_hit_sound_paths:
		ball_hit_sounds.append(load(sound_path))

func _process(delta):
	var velocity = Vector2(0, 0)
	
	if Input.is_action_pressed("ui_select"):
		handle_trigger()
	
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1;
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1;
	update_position(position + velocity.normalized() * speed * delta)

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			handle_trigger()
	elif event is InputEventMouseMotion:
		update_position(Vector2(event.position.x, position.y))

func update_position(new_position: Vector2):
	var width = $Body/Sprite.region_rect.size.x
	var prev_position = position
	position = new_position
	position.x = clamp(position.x, 60, screen_size.x - width / 2)
	for ball in attachedBalls:
		ball.position += position - prev_position
		
func handle_trigger():
	if attachedBalls:
		release_ball()
	else:
		shoot_pusher()

func release_ball():
	var ball = attachedBalls.pop_back()
	if ball:
		ball.go()
		ball.apply_central_impulse(Vector2(100, -500))
		
func shoot_pusher():
	var pusher = pusher_scn.instance()
	pusher.position = position + Vector2(0, -18)
	pusher.add_to_group("pushers")
	pusher.apply_central_impulse(Vector2(0, -1750))
	get_parent().add_child(pusher)
	return pusher

func accept_score(amount):
	score += amount

func ball_hit(_ball):
	if (ball_hit_sounds):
		player.stream = ball_hit_sounds[randi() % ball_hit_sounds.size()]
		player.play()
	else:
		print("no ball hit sounds defined, paths: " + str(ball_hit_sound_paths) + " sounds: " + str(ball_hit_sounds))
