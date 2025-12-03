class_name CameraController extends Node3D

@export var target: Node3D
@export var look_offset := Vector3(0, 1, 1)

@export var min_yaw_degrees: float = -15
@export var max_yaw_degrees: float = 15

@onready var _pitch: Node3D = $CameraPitch
@onready var camera: Camera3D = _pitch.get_node_or_null("Camera")

func _process(delta: float) -> void:
	if is_instance_valid(target):
		global_position = target.global_position
		var direction: Vector3 = target.global_position - global_position
		camera.look_at(target.global_position + look_offset.rotated(Vector3.UP, direction.y))

func add_pitch(amount: float) -> void:
	_pitch.rotation_degrees.x = clampf(_pitch.rotation_degrees.x + rad_to_deg(amount), min_yaw_degrees, max_yaw_degrees)
