class_name PlayerJumpState extends PlayerAirState

@export var _jump_animation_name: StringName = &"Jump"
@export var _jump_height: float = 6

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"Attack"):
		send_event(_hsm.ATTACK_EVENT)
	elif event.is_action_pressed(&"Skill"):
		send_event(_hsm.SKILL_EVENT)

func _enter() -> void:
	play_anim(_jump_animation_name)
	_player.velocity.y = sqrt(2 * _jump_height * _player.gravity_scale * _gravity)

func _update(delta: float) -> void:
	_player.turn_to_camera(delta)
	super._update(delta)
	var move_vector: Vector2 = Input.get_vector(&"ui_left", &"ui_right", &"ui_up", &"ui_down")
	_player.move(move_vector.normalized() * _mid_air_move_speed)
	if Input.is_action_just_pressed(&"Jump"):
		send_event(_hsm.JUMP_EVENT)
	elif Input.is_action_just_released(&"Jump"):
		_player.velocity.y /= 5
	elif _player.velocity.y <= 0:
		send_event(_hsm.FALL_EVENT)
	
