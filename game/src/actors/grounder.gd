class_name Grounder extends Node

@export var body: CharacterBody3D = get_owner()
@export var _ground_detector: RayCast3D
@export var gravity_scale: float = 10
@export var terminal_speed: float = 60

signal landed

var _current_floor: MaterialFloor
var _gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var _was_on_ground: bool = true

var _previous_gravity_scale: float

func _process(delta: float) -> void:
	_apply_gravity(delta)
	_check_ground()
	_update_ground.call_deferred()

func pause_gravity() -> void:
	_previous_gravity_scale = gravity_scale
	gravity_scale = 0

func resume_gravity() -> void:
	gravity_scale = _previous_gravity_scale

func _update_ground() -> void:
	if not _was_on_ground and body.is_on_floor():
		_land()
		landed.emit()
	_was_on_ground = body.is_on_floor()

func _apply_gravity(delta: float) -> void:
	body.velocity.y = max(-terminal_speed, body.velocity.y - _gravity * gravity_scale * delta)

func _check_ground() -> void:
	if is_instance_valid(_ground_detector) and _ground_detector.is_colliding():
		var colliding = _ground_detector.get_collider()
		if colliding is MaterialFloor:
			_current_floor = colliding

func _land() -> void:
	if is_instance_valid(_current_floor) and is_instance_valid(_current_floor.land_audio):
		AudioManager.play_clip(_current_floor.land_audio, false, body.global_position, 0.85, 1.15)

func play_footstep() -> void:
	if is_instance_valid(_current_floor):
		_current_floor.footsteps_audio.play_random(body.global_position, false, 0.85, 1.15)
