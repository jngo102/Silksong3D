@tool
extends BTAction

@export var vector_var := &"vector"

@export var output_x_var := &"x"
@export var output_y_var := &"y"
@export var output_z_var := &"z"

func _generate_name() -> String:
	return "Get Components of Vector %s→(%s, %s, %s)" % [
		LimboUtility.decorate_var(vector_var),
		LimboUtility.decorate_var(output_x_var),
		LimboUtility.decorate_var(output_y_var),
		LimboUtility.decorate_var(output_z_var),
	]

func _tick(_delta: float) -> Status:
	var vector: Vector3 = blackboard.get_var(vector_var)
	if vector == null:
		return FAILURE
	if blackboard.has_var(output_x_var):
		blackboard.set_var(output_x_var, vector.x)
	if blackboard.has_var(output_y_var):
		blackboard.set_var(output_y_var, vector.y)
	if blackboard.has_var(output_z_var):
		blackboard.set_var(output_z_var, vector.z)
	return SUCCESS
