@tool
extends BTAction

@export var from_var := &"from"
@export var to_var := &"to"

@export var output_distance_var := &"distance"

func _generate_name() -> String:
	return "Get Distance from %s to %s%s" % [
		LimboUtility.decorate_var(from_var),
		LimboUtility.decorate_var(to_var),
		LimboUtility.decorate_output_var(output_distance_var),
	]

func _tick(_delta: float) -> Status:
	var from: Node3D = blackboard.get_var(from_var)
	if not is_instance_valid(from):
		from = agent
	var to: Node3D = blackboard.get_var(to_var)
	if not is_instance_valid(to):
		return FAILURE
	var distance: float = from.global_position.distance_to(to.global_position)
	blackboard.set_var(output_distance_var, distance)
	return SUCCESS
