extends ColorRect

func _ready():
	print("Ready!")

func new_game():
	var result = get_tree().change_scene("res://GameScene.tscn")
	if result != OK:
		print("Error loading scene!")
