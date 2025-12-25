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

var _min_yaw_radians: float:
	get:
		return deg_to_rad(min_yaw_degrees)
var _max_yaw_radians: float:
	get:
		return deg_to_rad(max_yaw_degrees)

func _process(delta: float) -> void:
	if is_instance_valid(target):
		global_position = target.global_position

func add_pitch(amount: float) -> void:
	_pitch.rotation.x = clampf(_pitch.rotation.x + amount, _min_yaw_radians, _max_yaw_radians)
