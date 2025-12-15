class_name SpinSlashes extends Node3D

@export var antic_audio: AudioStream
@export var slash_audio: AudioStream

@onready var animator: AnimationPlayer = $Animator
@onready var audio: AudioStreamPlayer3D = $SlashAudio

func play_antic() -> void:
	animator.play(&"Spin Antic")
	audio.stream = antic_audio
	audio.play()

func reset() -> void:
	animator.play(&"RESET")

func play_slashes() -> void:
	animator.play(&"Slashes")
	audio.stream = slash_audio
	audio.play()
