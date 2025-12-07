@tool
extends BTAction

@export var x: float = NAN
@export var y: float = NAN
@export var z: float = NAN
@export var local: bool

func _generate_name() -> String:
	return "Set Position to (" + \
		("?" if is_nan(x) else str(x)) + ", " + \
		("?" if is_nan(y) else str(y)) + ", " + \
		("?" if is_nan(z) else str(z)) + ")"

func _tick(_delta: float) -> Status:
	var new_position: Vector3
	if local:
		new_position = agent.position
	else:
		new_position = agent.global_position
	if not is_nan(x):
		new_position.x = x
	if not is_nan(y):
		new_position.y = y
	if not is_nan(z):
		new_position.z = z
	if local:
		agent.position = new_position
	else:
		agent.global_position = new_position
	return SUCCESS
