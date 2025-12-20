class_name PlayerAttackChoiceState extends PlayerState

func _update(_delta: float) -> void:
	if not _player.is_on_floor() and _player.camera_controller.camera.global_rotation_degrees.x < -45:
		send_event(_hsm.DASH_EVENT)
	else:
		send_event(_hsm.ATTACK_EVENT)
