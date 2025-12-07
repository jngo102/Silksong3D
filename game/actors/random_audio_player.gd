class_name RandomAudioPlayer extends AudioStreamPlayer3D

@export var audio_clips: Array[AudioStream]

func play_random(from_position: float = 0) -> void:
	stream = audio_clips.pick_random()
	play(from_position)
