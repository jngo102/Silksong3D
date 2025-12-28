class_name PlayerCorpse extends Node3D

@onready var _death_voice: RandomAudioPlayer

func _ready() -> void:
	CameraManager.shake_camera(1, 2, false)
	var current_cam: CameraController = CameraManager.current_camera
	current_cam.target = self

func death_finish() -> void:
	SceneManager.reload()
