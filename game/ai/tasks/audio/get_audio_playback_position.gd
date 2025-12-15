@tool
extends BTAction

@export var audio_stream_player: BBNode

@export var output_time := &"time"

var _audio_player: AudioStreamPlayer

func _generate_name() -> String:
	return "Get Playback Position of %s %s" % [_audio_player, output_time]

func _setup() -> void:
	_audio_player = audio_stream_player.get_value(scene_root, blackboard)

func _tick(_delta: float) -> Status:
	if is_instance_valid(_audio_player):
		blackboard.set_var(output_time, _audio_player.get_playback_position())
		return SUCCESS
	return FAILURE
