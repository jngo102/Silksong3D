@tool
extends BTAction

@export var node_var: BBVariant

@export var visible: bool

func _generate_name() -> String:
	return "Set " + BBUtil.bb_var(node_var) + (" Visible" if visible else " Invisible")

func _tick(_delta: float) -> Status:
	var node = BBUtil.bb_value(node_var, blackboard, agent)
	if node == null:
		return FAILURE
	node.visible = visible
	return SUCCESS
