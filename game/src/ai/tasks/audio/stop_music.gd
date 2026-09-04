@tool
extends BTAction

@export var stream: MusicTrack
@export var immediate: bool

func _generate_name() -> String:
	return "Stop Music"

func _tick(_delta: float) -> Status:
	AudioManager.stop_music()
	return SUCCESS
