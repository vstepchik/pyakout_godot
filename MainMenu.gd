extends ColorRect

func _ready():
	print("Ready!")

func new_game():
	get_tree().change_scene("res://GameScene.tscn")
