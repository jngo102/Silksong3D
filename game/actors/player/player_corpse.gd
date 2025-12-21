class_name PlayerCorpse extends Node3D

@onready var _death_voice: RandomAudioPlayer

func death_finish() -> void:
	SceneManager.reload()
