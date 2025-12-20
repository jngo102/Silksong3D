class_name GroundedActor extends Actor

@export var gravity_scale: float = 10
@export var terminal_speed: float = 60

var _gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _process(delta: float) -> void:
	_apply_gravity(delta)
	super._process(delta)

func _apply_gravity(delta: float) -> void:
	velocity.y = max(-terminal_speed, velocity.y - _gravity * gravity_scale * delta)
