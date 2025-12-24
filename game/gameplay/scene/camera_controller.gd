@tool
class_name CameraController extends Node3D

@export var target: Node3D:
	set(value):
		target = value
		camera.target = value

@export var min_yaw_degrees: float = -15
@export var max_yaw_degrees: float = 15

@onready var _pitch: Node3D = $CameraPitch
@onready var camera: GameCamera = _pitch.get_node_or_null("Gimbal/Camera")

func _process(delta: float) -> void:
	if is_instance_valid(target):
		global_position = target.global_position

func add_pitch(amount: float) -> void:
	_pitch.rotation_degrees.x = clampf(_pitch.rotation_degrees.x + rad_to_deg(amount), min_yaw_degrees, max_yaw_degrees)
