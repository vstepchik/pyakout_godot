extends Node2D

func _init():
	pass

func hit(ball):
	ball.add_score(1)
	get_parent().queue_free()
