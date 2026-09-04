@tool
extends BTAction

@export var audio_player_var := &"audio_player"
@export var output_playback_position_var := &"music_playback_position"

func _generate_name() -> String:
	return "Get Audio Playback Position of %s%s" % [
		LimboUtility.decorate_var(audio_player_var),
		LimboUtility.decorate_output_var(output_playback_position_var),
	]

func _tick(_delta: float) -> Status:
	var audio_player: AudioStreamPlayer = blackboard.get_var(audio_player_var)
	if is_instance_valid(audio_player):
		var playback_position: float = audio_player.get_playback_position()
		blackboard.set_var(output_playback_position_var, playback_position)
		return SUCCESS
	return FAILURE
