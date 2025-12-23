class_name RoarEffect extends Node3D

@onready var _wave_sprite: Sprite3D = $Wave
@onready var _wave_animator: AnimationPlayer = _wave_sprite.get_node_or_null("Animator")
@onready var _lines_sprite: Sprite3D = $Lines

func shake_camera() -> void:
	var anim_length: float = _wave_animator.get_animation(&"Start").length
	CameraManager.shake_camera(2, anim_length)

func _process(delta: float) -> void:
	var camera_position: Vector3 = get_viewport().get_camera_3d().global_position
	camera_position.y = 0
	_wave_sprite.look_at(camera_position, Vector3.UP)
	_lines_sprite.look_at(camera_position, Vector3.UP)
