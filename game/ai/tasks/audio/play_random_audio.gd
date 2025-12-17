@tool
extends BTAction

@export var clips_array: Array[AudioStream]
@export var play_position_var := &"play_position"
@export var volume_scale: float = 1
@export var pitch_min: float = 1
@export var pitch_max: float = 1

func _generate_name() -> String:
	return "Play Random Audio at " + LimboUtility.decorate_var(play_position_var)

func _tick(_delta: float) -> Status:
	if len(clips_array) <= 0:
		return FAILURE
	var play_position: Vector3 = blackboard.get_var(play_position_var, Vector3.ZERO)
	var clip: AudioStream = clips_array.pick_random()
	AudioManager.play_clip(clip, false, play_position, pitch_min, pitch_max, volume_scale)
	return SUCCESS
