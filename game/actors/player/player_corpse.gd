class_name PlayerCorpse extends Node3D

@onready var _death_voice: RandomAudioPlayer

func _ready() -> void:
	CameraManager.shake_camera(1, 2, false)
	var current_cam: Camera3D = get_viewport().get_camera_3d()
	var cam_owner: Node = current_cam.owner
	if cam_owner is CameraController:
		cam_owner.clear_targets()
		cam_owner.add_target(self)

func death_finish() -> void:
	SceneManager.reload()
