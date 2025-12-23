@tool
extends BTAction

@export var duration_var: BBVariant

func _generate_name() -> String:
	return "Freeze Time for " + BBUtil.bb_var(duration_var)

func _tick(_delta: float) -> Status:
	var duration = BBUtil.bb_value(duration_var, blackboard)
	if duration != null:
		TimeManager.stop_time(true, duration)
		return SUCCESS
	return FAILURE
