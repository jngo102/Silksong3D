@tool
extends BTAction

@export var target_var := &"target"
@export var local: bool

@export var output_position_var := &"position"

func _generate_name() -> String:
	return "Get Position of %s%s" % [
		LimboUtility.decorate_var(target_var),
		LimboUtility.decorate_output_var(output_position_var),
	]

func _tick(_delta: float) -> Status:
	var target: Node3D = blackboard.get_var(target_var)
	if not is_instance_valid(target):
		target = agent
	var position: Vector3 = target.global_position
	if local:
		position = target.position
	blackboard.set_var(output_position_var, position)
	return SUCCESS
