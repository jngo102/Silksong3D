@tool
extends BTAction

@export var output_current_music_player_var := &"current_music_player"

func _generate_name() -> String:
	return "Get Current Music Player" + LimboUtility.decorate_output_var(output_current_music_player_var) 

func _tick(_delta: float) -> Status:
	var music_player: AudioStreamPlayer = AudioManager.current_music_player
	if not is_instance_valid(music_player):
		return FAILURE
	blackboard.set_var(output_current_music_player_var, music_player)
	return SUCCESS
