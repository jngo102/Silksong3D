@tool
extends BTAction

@export var root_node_var: BBVariant
@export var child_path: String
@export var get_node_path: bool
@export var child_output_var: StringName = &"child"

func _generate_name() -> String:
	return "Get Node " + child_path + " from " + BBUtil.bb_var(root_node_var) + LimboUtility.decorate_output_var(child_output_var)

func _tick(_delta: float) -> Status:
	var root_node = BBUtil.bb_value(root_node_var, blackboard, agent)
	if root_node == null or root_node is not Node:
		root_node = agent
	var child = root_node.get_node_or_null(child_path)
	if not is_instance_valid(child):
		return FAILURE
	if blackboard.has_var(child_output_var):
		if get_path:
			blackboard.set_var(child_output_var, child.get_path())
		else:
			blackboard.set_var(child_output_var, child)
	return SUCCESS
	
