class_name CogworkDasher extends Node3D

@export var min_appear_wait_time: float = 0.25
@export var max_appear_wait_time: float = 1
@export var min_dash_wait_time: float = 1
@export var max_dash_wait_time: float = 2
@export var max_dash_offset: float = 20

@onready var _animator: AnimationPlayer = $Animator
@onready var _voice_player: RandomAudioPlayer = $VoicePlayer

var finished_dashing: bool = true
var still_appearing: bool

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
	var wait_time: float = randf_range(min_appear_wait_time, max_appear_wait_time)
	await get_tree().create_timer(wait_time, false).timeout
	_animator.play(&"Appear")
	await _animator.animation_finished
	still_appearing = false

func dash() -> void:
	var wait_time: float = randf_range(min_dash_wait_time, max_dash_wait_time)
	await get_tree().create_timer(wait_time, false).timeout
	_voice_player.play_random()
	_animator.play(&"Dash")
	await _animator.animation_finished
	_animator.play(&"RESET")
	finished_dashing = true
