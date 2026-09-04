@tool
extends BTAction

@export var first_var: StringName= &""
@export var second_var: StringName = &""

@export var output_string_var := &"output"

func _generate_name() -> String:
	return "Concatenating %s and %s%s" % [
		LimboUtility.decorate_var(first_var),
		LimboUtility.decorate_var(second_var),
		LimboUtility.decorate_output_var(output_string_var)
	]

func _tick(_delta: float) -> Status:
	var first_value: Variant = blackboard.get_var(first_var)
	if first_value == null:
		return FAILURE
	var second_value: Variant = blackboard.get_var(second_var)
	if second_value == null:
		return FAILURE
	blackboard.set_var(output_string_var, str(first_value) + str(second_value))
	return SUCCESS
