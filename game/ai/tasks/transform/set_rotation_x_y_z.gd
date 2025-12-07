@tool
extends BTAction

@export var target_var := &"target"
@export var x: float = NAN
@export var y: float = NAN
@export var z: float = NAN
@export var local: bool

func _generate_name() -> String:
	return "Set Rotation to (" + \
		("?" if is_nan(x) else str(x)) + ", " + \
		("?" if is_nan(y) else str(y)) + ", " + \
		("?" if is_nan(z) else str(z)) + ")"

func _tick(_delta: float) -> Status:
	var target: Node3D = agent
	if blackboard.has_var(target_var):
		target = blackboard.get_var(target_var)
		if not is_instance_valid(target):
			target = agent
	var new_rotation: Vector3
	if local:
		new_rotation = target.rotation
	else:
		new_rotation = target.global_rotation
	if not is_nan(x):
		new_rotation.x = x
	if not is_nan(y):
		new_rotation.y = y
	if not is_nan(z):
		new_rotation.z = z
	if local:
		target.rotation = new_rotation
	else:
		target.global_rotation = new_rotation
	return SUCCESS
