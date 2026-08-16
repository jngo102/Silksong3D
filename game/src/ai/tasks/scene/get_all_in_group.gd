@tool
extends BTAction

## Name of the SceneTree group.
@export var group: StringName

## Blackboard variable in which the task will store the acquired nodes.
@export var output_var: StringName = &"targets"

func _generate_name() -> String:
	return "Get All Nodes In Group \"%s\"%s" % [
		group,
		LimboUtility.decorate_output_var(output_var)
	]

func _tick(_delta: float) -> Status:
	var nodes: Array[Node] = agent.get_tree().get_nodes_in_group(group)
	blackboard.set_var(output_var, nodes)
	return SUCCESS
