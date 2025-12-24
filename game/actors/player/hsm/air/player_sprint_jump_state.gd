class_name PlayerSprintJumpState extends PlayerAirState

@export var _sprint_jump_transition_tree: AnimationTree
@export var _sprint_jump_antic_animation_name: StringName = &"Sprint Jump Antic"
@export var _sprint_jump_animation_name: StringName = &"Sprint Jump"
@export var _sprint_jump_height: float = 16
@export var _sprint_jump_speed: float = 48
@export var _spin_speed: float = 720

var _sprint_jump_spin_audio: AudioStream = preload("uid://drbp2tq0bbbh6")

var _queue_stop_jump: bool

func _ready() -> void:
	await super._ready()
	_sprint_jump_transition_tree.animation_finished.connect(_on_animation_finish)

func _enter() -> void:
	AudioManager.play_clip(_sprint_jump_spin_audio, false, _player.global_position, 0.85, 1.15)
	_player.move(Vector2.UP * _sprint_jump_speed)
	_sprint_jump_transition_tree.set_active(true)
	_queue_stop_jump = false

func _exit() -> void:
	_sprint_jump_transition_tree.set_active(false)
	_player.armature.rotation.z = 0

func _update(delta: float) -> void:
	var playback: AnimationNodeStateMachinePlayback = _sprint_jump_transition_tree.get("parameters/playback")
	if playback.get_current_node() == _sprint_jump_animation_name:
		_player.armature.rotation_degrees.z += _spin_speed * delta
		super._update(delta)
		if Input.is_action_just_pressed(&"Jump"):
			send_event(_hsm.JUMP_EVENT)
		elif _player.velocity.y > 0 and (Input.is_action_just_released(&"Jump") or _queue_stop_jump):
			_queue_stop_jump = false
			_player.velocity.y /= 5
		elif _player.velocity.y < 0:
			send_event(_hsm.FALL_EVENT)
	elif Input.is_action_just_released(&"Jump"):
		_queue_stop_jump = true

func _jump() -> void:
	_player.velocity.y = sqrt(2 * _player.gravity_scale * _gravity * _sprint_jump_height)

func _on_animation_finish(anim_name: StringName) -> void:
	match anim_name:
		_sprint_jump_antic_animation_name:
			_jump()
