class_name PlayerFloatState extends PlayerAirState

@export var _cloak_animator: AnimationPlayer
@export var _float_transition_tree: AnimationTree
@export var _override_gravity_scale: float = 1
@export var _override_terminal_speed: float = 6
@export var _float_start_clip: AudioStream

var _original_gravity_scale: float
var _original_terminal_speed: float

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"Attack"):
		send_event(_hsm.ATTACK_EVENT)
	elif event.is_action_pressed(&"Skill"):
		send_event(_hsm.SKILL_EVENT)

func _enter() -> void:
	AudioManager.play_clip(_float_start_clip, false, _player.global_position, 0.85, 1.15)
	_cloak_animator.play(&"Puff Out")
	_float_transition_tree.set_active(true)
	_original_gravity_scale = _player.gravity_scale
	_original_terminal_speed = _player.terminal_speed
	_player.gravity_scale = 1
	_player.terminal_speed = _override_terminal_speed
	_player.velocity.y /= 4

func _exit() -> void:
	_cloak_animator.play(&"Unpuff")
	_float_transition_tree.set_active(false)
	_player.gravity_scale = _original_gravity_scale
	_player.terminal_speed = _original_terminal_speed

func _update(delta: float) -> void:
	super._update(delta)
	_player.turn_to_camera(delta)
	var move_vector: Vector2 = Input.get_vector(&"Left", &"Right", &"Forward", &"Backward")
	_player.move(move_vector.normalized() * _mid_air_move_speed)
	if Input.is_action_just_released(&"Jump"):
		send_event(_hsm.FALL_EVENT)
