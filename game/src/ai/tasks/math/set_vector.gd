@tool
extends BTAction

@export var target_vector_var := &"vector"
@export var value_vector_var: BBVariant

func _generate_name() -> String:
	return "Set Vector %s to %s" % [
		LimboUtility.decorate_var(target_vector_var),
		BBUtil.bb_var(value_vector_var),
	]

func _tick(_delta: float) -> Status:
	if not blackboard.has_var(target_vector_var):
		return FAILURE
	var value_vector = BBUtil.bb_value(value_vector_var, blackboard, agent)
	if value_vector != null:
		blackboard.set_var(target_vector_var, value_vector)
		return SUCCESS
	return FAILURE
