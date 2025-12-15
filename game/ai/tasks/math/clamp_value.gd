@tool
extends BTAction

@export var value_var := &"value"
@export var min_var: BBVariant
@export var max_var: BBVariant

func _generate_name() -> String:
	return "Clamp %s Between %s and %s" % [
		LimboUtility.decorate_var(value_var),
		BBUtil.bb_var(min_var),
		BBUtil.bb_var(max_var),
	]

func _tick(_delta: float) -> Status:
	var value: float = blackboard.get_var(value_var)
	if value == null:
		return FAILURE
	var min_value = BBUtil.bb_value(min_var, blackboard)
	if min_value == null:
		min_value = -INF
	var max_value = BBUtil.bb_value(max_var, blackboard)
	if max_value == null:
		max_value = INF
	var clamped_value: float = clampf(value, min_value, max_value)
	blackboard.set_var(value_var, clamped_value)
	return SUCCESS
