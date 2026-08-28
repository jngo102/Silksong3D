@tool
extends BTAction

@export var input_action_var: BBVariant

func _generate_name() -> String:
	return "Wait for Input Action " + BBUtil.bb_var(input_action_var)

func _tick(_delta: float) -> Status:
	var input_action: StringName = BBUtil.bb_value(input_action_var, blackboard, agent)
	if input_action == null:
		return FAILURE
	if not Input.is_action_pressed(input_action):
		print("INPUT: ", input_action)
		return RUNNING
	print("PRESSED INPUT")
	return SUCCESS
