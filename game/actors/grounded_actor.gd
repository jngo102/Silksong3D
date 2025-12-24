class_name GroundedActor extends Actor

@export var gravity_scale: float = 10
@export var terminal_speed: float = 60

@onready var _ground_detector: RayCast3D = $GroundDetector

signal landed

var _current_floor: MaterialFloor
var _gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var _was_on_ground: bool

func _process(delta: float) -> void:
	_apply_gravity(delta)
	_check_ground()
	super._process(delta)
	if not _was_on_ground and is_on_floor():
		_land()
		landed.emit()
	_was_on_ground = is_on_floor()

func _apply_gravity(delta: float) -> void:
	velocity.y = max(-terminal_speed, velocity.y - _gravity * gravity_scale * delta)

func _check_ground() -> void:
	if _ground_detector.is_colliding():
		var colliding = _ground_detector.get_collider()
		if colliding is MaterialFloor:
			_current_floor = colliding

func _land() -> void:
	if is_instance_valid(_current_floor) and is_instance_valid(_current_floor.land_audio):
		AudioManager.play_clip(_current_floor.land_audio, false, global_position, 0.85, 1.15)

func play_footstep() -> void:
	if is_instance_valid(_current_floor):
		_current_floor.footsteps_audio.play_random(global_position, false, 0.85, 1.15)
