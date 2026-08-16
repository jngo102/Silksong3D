class_name CameraController extends Node3D

@export var shake_interval: float = 0.025

## The amount of shake to remove every frame
var unshake_amount: float
## The current shake vector applied to the object
var current_shake_vector: Vector3
## The current amount of shake applied to the object
var current_shake_magnitude: float
## The current time that the object has been offset for during a shake
var current_shake_time: float = INF

@export var target: Node3D

var _shake_timer: float = INF
var _shake_duration: float

@export var min_yaw_degrees: float = -15
@export var max_yaw_degrees: float = 15

@onready var _pitch: Node3D = $CameraPitch
@onready var camera: Camera3D = _pitch.get_node_or_null("Gimbal/Camera")

var shaking: bool:
	get:
		return _shake_timer < _shake_duration

var _min_yaw_radians: float:
	get:
		return deg_to_rad(min_yaw_degrees)
var _max_yaw_radians: float:
	get:
		return deg_to_rad(max_yaw_degrees)

func _process(delta: float) -> void:
	if shaking:
		_shake_timer += delta
		current_shake_time += delta
		if current_shake_time >= shake_interval:
			update_shake()
	else:
		_pitch.position = Vector3.ZERO
		if is_instance_valid(target):
			camera.look_at(target.global_position)

	if is_instance_valid(target):
		global_position = target.global_position

## Begin object shake in all directions
func shake(amount: float = 0.5, duration: float = 0.25, taper_off: bool = true) -> void:
	if shaking:
		return
	current_shake_magnitude = amount * SaveManager.settings.screen_shake_intensity
	_shake_timer = 0
	current_shake_time = 0
	unshake_amount = (current_shake_magnitude / duration) if taper_off else 0
	_shake_duration = duration

## Update the current object shake
func update_shake() -> void:
	current_shake_vector = Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)).normalized() * current_shake_magnitude
	_pitch.position = current_shake_vector
	if is_instance_valid(target):
		camera.look_at(target.global_position - current_shake_vector)
		camera.global_rotation.z = 0
	current_shake_magnitude -= unshake_amount * current_shake_time
	current_shake_time = 0

func add_yaw(amount: float) -> void:
	rotation.y += amount

func add_pitch(amount: float) -> void:
	_pitch.rotation.x = clampf(_pitch.rotation.x + amount, _min_yaw_radians, _max_yaw_radians)
