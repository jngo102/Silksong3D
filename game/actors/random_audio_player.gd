class_name RandomAudioPlayer extends AudioStreamPlayer3D

@export var audio_clips: Array[AudioStream]

var _previous_clip: AudioStream

func play_random(from_position: float = 0, pitch_min: float = 1, pitch_max: float = 1) -> void:
	while len(audio_clips) > 1 and stream == _previous_clip:
		stream = audio_clips.pick_random()
	pitch_scale = randf_range(pitch_min, pitch_max)
	play(from_position)
	_previous_clip = stream
