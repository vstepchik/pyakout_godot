extends StaticBody2D

signal score_accepted
signal ball_hit

func accept_score(amount):
	emit_signal("score_accepted", amount)

func hit(ball):
	emit_signal("ball_hit", ball)
