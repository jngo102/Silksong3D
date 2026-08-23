@tool
extends BTAction

@export var from_var: BBVariant
@export var to_var: BBVariant

@export var output_distance_var := &"distance"

func _generate_name() -> String:
	return "Get Distance from %s to %s%s" % [
		BBUtil.bb_var(from_var),
		BBUtil.bb_var(to_var),
		LimboUtility.decorate_output_var(output_distance_var),
	]

func _tick(_delta: float) -> Status:
	var from = BBUtil.bb_value(from_var, blackboard, agent)
	if not is_instance_valid(from):
		from = agent
	var to = BBUtil.bb_value(to_var, blackboard, agent)
	if not is_instance_valid(to):
		return FAILURE
	var distance: float = from.global_position.distance_to(to.global_position)
	blackboard.set_var(output_distance_var, distance)
	return SUCCESS
