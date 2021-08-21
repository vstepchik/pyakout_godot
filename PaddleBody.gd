extends StaticBody2D

signal score_accepted

func accept_score(amount):
	emit_signal("score_accepted", amount)
