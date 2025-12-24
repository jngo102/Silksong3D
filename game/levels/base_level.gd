## Base class for all levels in the game
class_name BaseLevel extends Node3D

## The music track played in this scene
@export var music_track: MusicTrack
@export var starting_score: int = 100000

@onready var player: Player = $Player

var _score_screen: PackedScene = preload("uid://dcvpcta71mmie")

func _ready() -> void:
	_play_music()

func _play_music() -> void:
	if music_track:
		AudioManager.play_music(music_track)

func finish() -> void:
	ScoreManager.calculate_score()
	await get_tree().create_timer(8, false).timeout
	SceneManager.change_scene(_score_screen)
