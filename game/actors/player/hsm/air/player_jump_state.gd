class_name PlayerJumpState extends PlayerAirState

@export var _jump_animation_name: StringName = &"Jump"
@export var _jump_height: float = 6
@export var _jump_voice: RandomAudioPlay

var _jump_audio: AudioStream = preload("uid://84tivhr2n1ui")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"Attack"):
		send_event(_hsm.ATTACK_EVENT)
	elif event.is_action_pressed(&"Skill"):
		send_event(_hsm.SKILL_EVENT)

func _enter() -> void:
	AudioManager.play_clip(_jump_audio, false, _player.global_position, 0.85, 1.15)
	if randf_range(0, 1) > 0.25:
		_jump_voice.play_random(_player.global_position, false, 0.85, 1.15)
	play_anim(_jump_animation_name)
	_player.velocity.y = sqrt(2 * _jump_height * _player.gravity_scale * _gravity)

func _update(delta: float) -> void:
	_player.turn_to_camera(delta)
	super._update(delta)
	var move_vector: Vector2 = Input.get_vector(&"ui_left", &"ui_right", &"ui_up", &"ui_down")
	_player.move(move_vector.normalized() * _mid_air_move_speed)
	if Input.is_action_just_pressed(&"Jump"):
		send_event(_hsm.JUMP_EVENT)
	elif not Input.is_action_pressed(&"Jump") and _player.velocity.y > 1:
		_player.velocity.y /= 2
	elif _player.velocity.y <= 0:
		send_event(_hsm.FALL_EVENT)
	
