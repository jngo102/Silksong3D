@tool
extends BTAction

## Blackboard variable that stores our target (expecting Node3D).
@export var target_var: StringName = &""

@export var output_direction_var: StringName = &""

func _generate_name() -> String:
	return "Get Direction to Target %s%s" % [
		LimboUtility.decorate_var(target_var),
		LimboUtility.decorate_output_var(output_direction_var),
	]

func _tick(_delta: float) -> Status:
	var target: Node3D = blackboard.get_var(target_var)
	if not is_instance_valid(target):
		return FAILURE
	var direction: Vector3 = agent.global_position.direction_to(target.global_position)
	blackboard.set_var(output_direction_var, direction)
	return SUCCESS
