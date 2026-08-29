@tool
extends BTAction

@export var health_component_var: BBVariant

@export var output_health_value_var: StringName = &"health"

func _generate_name() -> String:
	return "Get Health of %s%s" % [
		BBUtil.bb_var(health_component_var),
		LimboUtility.decorate_output_var(output_health_value_var)
	]

func _tick(_delta: float) -> Status:
	var health_component = BBUtil.bb_value(health_component_var, blackboard, agent)
	if not is_instance_valid(health_component):
		if agent is Actor:
			health_component = agent.health
		else:
			return FAILURE
	var health_value = health_component.current_health
	if blackboard.has_var(output_health_value_var):
		blackboard.set_var(output_health_value_var, health_value)
		return SUCCESS
	return FAILURE
