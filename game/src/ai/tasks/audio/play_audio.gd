@tool
extends BTAction

@export var audio_player_path: BBVariant
@export var stream: AudioStream

func _generate_name() -> String:
	return "Play " + stream.resource_name + " at " + BBUtil.bb_var(audio_player_path)

func _tick(_delta: float) -> Status:
	var audio_player = BBUtil.bb_value(audio_player_path, blackboard, agent)
	if not is_instance_valid(audio_player):
		return FAILURE
	if audio_player is AudioPlayer3D:
		audio_player.stream = stream
		audio_player.play()
	return SUCCESS
