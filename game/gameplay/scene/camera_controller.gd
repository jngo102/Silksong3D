@tool
class_name CameraController extends Node3D

@export var min_pitch_degrees: float = -59
@export var max_pitch_degrees: float = 60

@onready var _pitch: Node3D = $CameraPitch
@onready var camera: GameCamera = _pitch.get_node_or_null("Gimbal/Camera")

var _min_pitch_radians: float:
	get:
		return deg_to_rad(min_pitch_degrees)
var _max_pitch_radians: float:
	get:
		return deg_to_rad(max_pitch_degrees)

var targets: Array[Node3D]
var valid_targets: Array[Node3D]:
	get:
		return targets.filter(func(target):
			return is_instance_valid(target))
var target_count: int:
	get:
		return len(valid_targets)
var midpoint: Vector3:
	get:
		var point := Vector3.ZERO
		if len(valid_targets) > 0:
			for target in valid_targets:
				if is_instance_valid(target):
					point += target.global_position
			point /= target_count
		return point

func _process(delta: float) -> void:
	if target_count > 0:
		global_position = targets[0].global_position	
		if target_count > 1:
			var others_midpoint := Vector3.ZERO
			var main_target: Node3D = valid_targets[0]
			for target in valid_targets:
				if target == main_target:
					continue
				others_midpoint += target.global_position
			others_midpoint /= target_count
			look_at(others_midpoint)
			#var midpoint_to_main_target_vector: Vector3 = main_target.global_position - others_midpoint
			#
		else:
			rotation.x = 0
			rotation.z = 0

func add_target(target: Node3D) -> void:
	targets.append(target)
	camera.targets.append(target)

func remove_target(target: Node3D) -> void:
	targets.erase(target)
	camera.targets.erase(target)

func clear_targets() -> void:
	targets.clear()
	camera.targets.clear()

func add_yaw(amount: float) -> void:
	if target_count <= 1:
		rotation.y += amount

func add_pitch(amount: float) -> void:
	if target_count <= 1:
		_pitch.rotation.x = clampf(_pitch.rotation.x + amount, _min_pitch_radians, _max_pitch_radians)
