@tool
extends BTAction

@export var clips_array: Array[AudioStream]
@export var play_position_var := &"play_position"
@export var volume_scale: float = 1
@export var pitch_min: float = 1
@export var pitch_max: float = 1
@export var range: float = 64

@export var output_audio_player_var: StringName = &"audio_player"

var _previous_clip: AudioStream

func _generate_name() -> String:
	return "Play Random Audio at " + LimboUtility.decorate_var(play_position_var)

func _tick(_delta: float) -> Status:
	if len(clips_array) <= 0:
		return FAILURE
	var play_position: Vector3 = blackboard.get_var(play_position_var, Vector3.ZERO)
	var clip: AudioStream = clips_array.pick_random()
	while len(clips_array) > 1 and clip == _previous_clip:
		clip = clips_array.pick_random()
	var audio_player: Node = AudioManager.play_clip(clip, false, "SFX", play_position, pitch_min, pitch_max, volume_scale, range)
	_previous_clip = clip
	if blackboard.has_var(output_audio_player_var):
		blackboard.set_var(output_audio_player_var, audio_player)
	return SUCCESS
