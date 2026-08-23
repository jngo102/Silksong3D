@tool
extends BTAction

@export var min_var: BBVariant
@export var max_var: BBVariant

@export var output_value_var := &"output"

func _generate_name() -> String:
	return "randf_range(%s, %s)%s" % [
		BBUtil.bb_var(min_var),
		BBUtil.bb_var(max_var),
		LimboUtility.decorate_output_var(output_value_var),
	]

func _tick(_delta: float) -> Status:
	var min = BBUtil.bb_value(min_var, blackboard)
	if min == null:
		min = 0.0
	var max = BBUtil.bb_value(max_var, blackboard)
	if max == null:
		max = 0.0
	var value: float = randf_range(min, max)
	if blackboard.has_var(output_value_var):
		blackboard.set_var(output_value_var, value)
	return SUCCESS
