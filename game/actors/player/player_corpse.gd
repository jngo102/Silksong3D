class_name PlayerCorpse extends Node3D

@onready var _death_voice: RandomAudioPlayer

func _ready() -> void:
	CameraManager.shake_camera(1, 2, false)

func death_finish() -> void:
	SceneManager.reload()
