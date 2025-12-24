class_name PlayerGroundState extends PlayerState

@export var _footstep_interval: float = 0.6

var _footstep_timer: float

func _enter() -> void:
	_footstep_timer = 0

func _update(delta: float) -> void:
	super._update(delta)
	if not _player.is_on_floor() and _player.velocity.y < 0:
		send_event(_hsm.FALL_EVENT)
	elif _player.is_on_floor() and (Input.is_action_just_pressed(&"Jump") or InputManager.is_buffered(&"Jump")):
		send_event(_hsm.JUMP_EVENT)
	_footstep_timer += delta
	if _footstep_timer > _footstep_interval:
		_footstep_timer = 0
		_player.play_footstep()
