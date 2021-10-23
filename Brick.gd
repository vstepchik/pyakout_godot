extends Node2D

var files = []

func _ready():
	randomize()
	for i in range(23, 41):
		files.append("res://res/sounds/sound_0" + str(i) + ".wav")
	var file_number = randi() % files.size()
	$Sprite/HitSoundPlayer.stream = load(files[file_number])

func on_hit():
	$Body.queue_free()
	$Sprite.visible = false
	$Sprite/HitSoundPlayer.play()

func _on_HitSoundPlayer_finished():
	queue_free()
