@tool
extends BTAction

@export var value_var: BBVariant
@export var compare_var: BBVariant

func _generate_name() -> String:
	return "Is %s Approximately Equal to %s" % [
		BBUtil.bb_var(value_var),
		BBUtil.bb_var(compare_var),
	]

func _tick(_delta: float) -> Status:
	var value = BBUtil.bb_value(value_var, blackboard)
	if value == null:
		return FAILURE
	var compare_value = BBUtil.bb_value(compare_var, blackboard)
	if compare_value == null:
		return FAILURE
	#print(value, " == ", compare_value, ": ", is_equal_approx(value, compare_value))
	if is_equal_approx(value, compare_value):
		return SUCCESS
	return FAILURE
