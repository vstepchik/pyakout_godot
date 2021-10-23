extends Node2D

func hit(ball):
	ball.add_score(1)
	get_parent().on_hit()
