@tool
extends BTAction

@export var stream: MusicTrack
@export var immediate: bool

func _generate_name() -> String:
	return "Play Music " + stream.resource_name + (" Immediately" if immediate else "")

func _tick(_delta: float) -> Status:
	if is_instance_valid(stream):
		AudioManager.play_music(stream, 0, immediate)
	else:
		AudioManager.stop_music()
	return SUCCESS
