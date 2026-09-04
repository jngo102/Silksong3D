@tool
extends BTAction

@export var audio_player_var := &"audio_player"
@export var output_duration_var := &"audio_duration"

func _generate_name() -> String:
	return "Get Duration of Audio Player %s%s" % [
		LimboUtility.decorate_var(audio_player_var),
		LimboUtility.decorate_output_var(output_duration_var),
	]

func _tick(_delta: float) -> Status:
	var audio_player: AudioStreamPlayer = blackboard.get_var(audio_player_var)
	if is_instance_valid(audio_player):
		var stream: AudioStream = audio_player.stream
		if is_instance_valid(stream):
			blackboard.set_var(output_duration_var, stream.get_length())
			return SUCCESS
	return FAILURE
