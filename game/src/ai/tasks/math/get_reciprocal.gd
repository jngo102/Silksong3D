@tool
extends BTAction

@export var value_var := &"value"

func _generate_name() -> String:
	return "Get Reciprocal of " + LimboUtility.decorate_var(value_var)

func _tick(_delta: float) -> Status:
	var value: float = blackboard.get_var(value_var)
	if value == null:
		return FAILURE
	var reciprocal: float = 1.0 / value
	blackboard.set_var(value_var, reciprocal)
	return SUCCESS
