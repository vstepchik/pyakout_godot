extends RigidBody2D

onready var alive = true
onready var last_collision_velocity = 0.0

func _on_Pusher_body_entered(body):
	if not alive:
		return
	if body.is_in_group("balls"):
		$Sprite/HitSoundPlayer.play()
	$Sprite.visible = false
	alive = false

func _on_HitSoundPlayer_finished():
	queue_free()

func _integrate_forces(state):
	if not alive:
		$Shape.set_deferred("disabled", true)
	if state.get_contact_count() > 0 and state.get_contact_collider_object(0).is_in_group("balls"):
		last_collision_velocity = state.get_contact_collider_velocity_at_position(0).length()
		#print(state.get_contact_local_normal(0))
		#if last_collision_velocity > 0:
			#print("vel: " + str(last_collision_velocity))
