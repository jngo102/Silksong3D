## Base class for all levels in the game
class_name BaseLevel extends Node

## The music track played in this scene
@export var music_track: MusicTrack

func _ready() -> void:
	_play_music()

func _play_music() -> void:
	if music_track:
		AudioManager.play_music(music_track)
