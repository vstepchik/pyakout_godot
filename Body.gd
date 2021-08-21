extends RigidBody2D

var acc: Vector2 = Vector2()

func _ready():
	pass # Replace with function body.

func _integrate_forces(state):
	if acc.length() > 0:
		applied_force = acc

func accelerate(vec):
	acc = vec
