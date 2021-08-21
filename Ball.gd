extends RigidBody2D

var score = 0

func _ready():
	pass

func go():
	mode = MODE_RIGID

func add_score(amount):
	score += amount

func _on_Ball_body_entered(body):
	if body.has_method("hit"):
		body.hit(self)
	if body.has_method("accept_score"):
		body.accept_score(score)
		score = 0
