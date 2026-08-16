@tool
extends BTAction

@export var health_component_var: BBVariant

@export var health_value_var: BBVariant

func _generate_name() -> String:
	return "Set Health to " + BBUtil.bb_var(health_value_var)

func _tick(_delta: float) -> Status:
	var health_component = BBUtil.bb_value(health_component_var, blackboard)
	if not is_instance_valid(health_component):
		if agent is Actor:
			health_component = agent.health
		else:
			return FAILURE
	var health_value = BBUtil.bb_value(health_value_var, blackboard)
	if health_value != null:
		health_component.current_health = health_value
		return SUCCESS
	return FAILURE
