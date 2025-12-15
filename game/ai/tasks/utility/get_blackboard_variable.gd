@tool
extends BTAction

@export var agent_var := &"agent"
@export var variable_name: String

@export var output_variable_var := &"output_variable"

func _generate_name() -> String:
	return "Get Blackboard Variable %s of %s%s" % [
		variable_name,
		LimboUtility.decorate_var(agent_var),
		LimboUtility.decorate_output_var(output_variable_var),
	]

func _tick(_delta: float) -> Status:
	var this_agent: Node = blackboard.get_var(agent_var)
	if is_instance_valid(this_agent):
		var behavior_tree: BTPlayer = this_agent.get_node("BehaviorTree")
		if is_instance_valid(behavior_tree):
			var result: Variant = behavior_tree.blackboard.get_var(variable_name)
			if result != null:
				blackboard.set_var(output_variable_var, result)
				return SUCCESS
	return FAILURE
