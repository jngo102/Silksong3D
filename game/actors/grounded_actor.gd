class_name GroundedActor extends Actor

@export var gravity_scale: float = 10
@export var terminal_speed: float = 60

signal landed

var _gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var _was_on_ground: bool

func _process(delta: float) -> void:
	_apply_gravity(delta)
	super._process(delta)
	if not _was_on_ground and is_on_floor():
		landed.emit()
	_was_on_ground = is_on_floor()

func _apply_gravity(delta: float) -> void:
	velocity.y = max(-terminal_speed, velocity.y - _gravity * gravity_scale * delta)
