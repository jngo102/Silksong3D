@tool
extends BTAction

@export var vector_var := &"vector"

@export var output_length_var := &"length"

func _generate_name() -> String:
	return "Get Length of Vector %s→%s" % [
		LimboUtility.decorate_var(vector_var),
		LimboUtility.decorate_var(output_length_var),
	]

func _tick(_delta: float) -> Status:
	var vector: Vector3 = blackboard.get_var(vector_var)
	if vector == null:
		return FAILURE
	if blackboard.has_var(output_length_var):
		blackboard.set_var(output_length_var, vector.length())
	return SUCCESS
