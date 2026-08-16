@tool
extends BTAction

@export var array_var := &"array"
@export var element_var := &"element"

@export var output_index_var := &"output"

func _generate_name() -> String:
	return "Get Index of Element %s in Array %s%s" % [
		LimboUtility.decorate_var(array_var),
		LimboUtility.decorate_var(element_var),
		LimboUtility.decorate_output_var(output_index_var),
	]

func _tick(_delta: float) -> Status:
	var array: Array = blackboard.get_var(array_var)
	if array == null or len(array) <= 0:
		return FAILURE
	var element: Variant = blackboard.get_var(element_var)
	if element == null:
		return FAILURE
	var index: int = array.find(element)
	blackboard.set_var(output_index_var, index)
	return SUCCESS
