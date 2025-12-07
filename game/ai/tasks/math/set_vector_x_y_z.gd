@tool
extends BTAction

@export var vector_var := &"vector"
@export var x_var := &"x"
@export var y_var := &"y"
@export var z_var := &"z"

func _generate_name() -> String:
	return "Set Components of Vector %s→(%s, %s, %s)" % [
		LimboUtility.decorate_var(vector_var),
		LimboUtility.decorate_var(x_var),
		LimboUtility.decorate_var(y_var),
		LimboUtility.decorate_var(z_var),
	]

func _tick(_delta: float) -> Status:
	if not blackboard.has_var(vector_var):
		return FAILURE
	var vector: Vector3 = blackboard.get_var(vector_var)
	if blackboard.has_var(x_var):
		var x: float = blackboard.get_var(x_var)
		vector.x = x
	if blackboard.has_var(y_var):
		var y: float = blackboard.get_var(y_var)
		vector.y = y
	if blackboard.has_var(z_var):
		var z: float = blackboard.get_var(z_var)
		vector.z = z
	blackboard.set_var(vector_var, vector)
	return SUCCESS
