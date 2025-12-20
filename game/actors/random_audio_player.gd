class_name RandomAudioPlayer extends AudioStreamPlayer3D

@export var audio_clips: Array[AudioStream]

func play_random(from_position: float = 0, pitch_min: float = 1, pitch_max: float = 1) -> void:
	stream = audio_clips.pick_random()
	pitch_scale = randf_range(pitch_min, pitch_max)
	play(from_position)
