## A set of clips to play at random
class_name RandomAudioPlay extends Resource

## A list of clips to choose from
@export var clips: Array[AudioStream] = []

var _previous_clip: AudioStream

## Play a random clip
func play_random(play_position := Vector3.ZERO, global: bool = false, pitch_min: float = 1, pitch_max: float = 1, volume_scale: float = 1, range: float = 24) -> void:
	var clip: AudioStream = clips.pick_random()
	while len(clips) > 1 and clip == _previous_clip:
		clip = clips.pick_random()
	AudioManager.play_clip(clip, false, play_position, pitch_min, pitch_max, volume_scale, range)
	_previous_clip = clip
