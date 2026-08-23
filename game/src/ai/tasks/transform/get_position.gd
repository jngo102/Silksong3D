@tool
extends BTAction

@export var target_var: BBVariant
@export var local: bool

@export var output_position_var := &"position"

func _generate_name() -> String:
	return "Get Position of %s%s" % [
		BBUtil.bb_var(target_var),
		LimboUtility.decorate_output_var(output_position_var),
	]

func _tick(_delta: float) -> Status:
	var target = BBUtil.bb_value(target_var, blackboard, agent)
	if not is_instance_valid(target):
		target = agent
	var position: Vector3 = target.global_position
	if local:
		position = target.position
	blackboard.set_var(output_position_var, position)
	return SUCCESS
