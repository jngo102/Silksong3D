@tool
extends BTAction

@export var node_var: BBVariant
@export var new_parent_var: BBVariant
@export var keep_world_position: bool = true

func _generate_name() -> String:
	return "Reparent " + BBUtil.bb_var(node_var) + " to " + BBUtil.bb_var(new_parent_var)

func _tick(_delta: float) -> Status:
	var node = BBUtil.bb_value(node_var, blackboard, agent)
	if node == null:
		return FAILURE
	var parent = BBUtil.bb_value(new_parent_var, blackboard, agent)
	if parent == null:
		return FAILURE
	if node is Node and parent is Node:
		node.reparent(parent, keep_world_position)
		return SUCCESS
	return FAILURE
