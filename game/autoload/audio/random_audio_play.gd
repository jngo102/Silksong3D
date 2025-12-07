## A set of clips to play at random
class_name RandomAudioPlay extends Resource

## A list of clips to choose from
@export var clips: Array[AudioStream] = []

## Play a random clip
func play_random(play_position: Vector3, pitch_min: float = 1, pitch_max: float = 1) -> void:
	AudioManager.play_clip(clips.pick_random(), play_position, pitch_min, pitch_max)
