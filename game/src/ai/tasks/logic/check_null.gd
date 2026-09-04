@tool
extends BTAction

@export var check_var: BBVariant

func _generate_name() -> String:
	return "Check Whether %s is null" % BBUtil.bb_var(check_var)

func _tick(_delta: float) -> Status:
	var check = BBUtil.bb_value(check_var, blackboard, agent)
	if check == null:
		return SUCCESS
	return FAILURE
