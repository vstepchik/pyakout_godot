extends Node2D

var files = []

func _ready():
	var file_number = 23 + (randi() % 18)
	$Sprite/HitSoundPlayer.stream = load("res://res/sounds/sound_0" + str(file_number) + ".wav")
	$Sprite.region_rect.position = random_texture_position()

func on_hit():
	$Body.queue_free()
	$Sprite.visible = false
	$Sprite/HitSoundPlayer.play()

func _on_HitSoundPlayer_finished():
	queue_free()

func random_texture_position():
	return Vector2(96 + (randi() % 7) * 32, 0 + (randi() % 2) * 16)
	
func set_color(color: Color):
	$Sprite.modulate = color
	
func random_modulate_color():
	var r = float(127 + (randi() % 4 * 32)) / 255.0
	var g = float(127 + (randi() % 4 * 32)) / 255.0
	var b = float(127 + (randi() % 4 * 32)) / 255.0
	return Color(r, g, b)
