@tool
extends BTAction

@export var array_var := &"array"

@export var output_var := &"output"

func _generate_name() -> String:
	return "Choose Random Element from Array %s%s" % [
		LimboUtility.decorate_var(array_var),
		LimboUtility.decorate_output_var(output_var),
	]

func _tick(_delta: float) -> Status:
	var array: Array = blackboard.get_var(array_var)
	if array == null or len(array) <= 0:
		return FAILURE
	var choice: Variant = array.pick_random()
	blackboard.set_var(output_var, choice)
	return SUCCESS
