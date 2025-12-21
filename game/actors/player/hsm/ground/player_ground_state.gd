class_name PlayerGroundState extends PlayerState

func _update(delta: float) -> void:
	super._update(delta)
	if not _player.is_on_floor() and _player.velocity.y < 0:
		send_event(_hsm.FALL_EVENT)
	elif _player.is_on_floor() and (Input.is_action_just_pressed(&"Jump") or InputManager.is_buffered(&"Jump")):
		send_event(_hsm.JUMP_EVENT)
