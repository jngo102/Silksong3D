@tool
extends BTAction

@export var tree_var: BBVariant
@export var variable_name: String

@export var output_variable_var := &"output_variable"

func _generate_name() -> String:
	return "Get Blackboard Variable %s of %s%s" % [
		variable_name,
		BBUtil.bb_var(tree_var),
		LimboUtility.decorate_output_var(output_variable_var),
	]

func _tick(_delta: float) -> Status:
	var bt: BTPlayer = BBUtil.bb_value(tree_var, blackboard, agent)
	if is_instance_valid(bt):
		var result = bt.blackboard.get_var(variable_name)
		if result != null:
			blackboard.set_var(output_variable_var, result)
	return SUCCESS
