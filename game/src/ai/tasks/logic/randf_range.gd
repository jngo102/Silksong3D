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
	var min_value = BBUtil.bb_value(min_var, blackboard, agent)
	if min_value == null:
		min_value = 0.0
	var max_value = BBUtil.bb_value(max_var, blackboard, agent)
	if max_value == null:
		max_value = 0.0
	var value: float = randf_range(min_value, max_value)
	if blackboard.has_var(output_value_var):
		blackboard.set_var(output_value_var, value)
	return SUCCESS
