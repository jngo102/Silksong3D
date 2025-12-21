class_name CogworkDasher extends Node3D

@export var min_wait_time: float = 1
@export var max_wait_time: float = 2
@export var max_dash_offset: float = 20

@onready var _animator: AnimationPlayer = $Animator
@onready var _voice_player: RandomAudioPlayer = $VoicePlayer
@onready var _dash_audio: AudioStreamPlayer3D = $DashAudio

var finished_dashing: bool = true
var still_appearing: bool

var _wait_time: float

func appear() -> void:
	if still_appearing:
		return
	finished_dashing = false
	still_appearing = true
	rotation_degrees = Vector3(randf_range(-180, 180), randf_range(0, 360), 0)
	position = Vector3(
		randf_range(-max_dash_offset, max_dash_offset), 
		0,
		randf_range(-max_dash_offset, max_dash_offset)
	)
	_wait_time = randf_range(min_wait_time, max_wait_time)
	await get_tree().create_timer(_wait_time, false).timeout
	_animator.play(&"Appear")
	await _animator.animation_finished
	still_appearing = false

func dash() -> void:
	await get_tree().create_timer(_wait_time, false).timeout
	_voice_player.play_random()
	_dash_audio.play()
	_animator.play(&"Dash")
	#CameraManager.shake_camera(1, 0.25)
	await _animator.animation_finished
	_animator.play(&"RESET")
	finished_dashing = true
