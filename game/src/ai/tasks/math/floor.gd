@tool
extends BTAction

@export var value_var := &"value"

func _generate_name() -> String:
	return "Floor " + LimboUtility.decorate_var(value_var)

func _tick(_delta: float) -> Status:
	var value: float = blackboard.get_var(value_var)
	if value == null:
		return FAILURE
	var floored_value: float = floorf(value)
	blackboard.set_var(value_var, floored_value)
	return SUCCESS
