@tool
extends BTAction

@export var target_var: BBVariant
@export var vector_var: BBVariant
@export var local: bool

func _generate_name() -> String:
	return "Set %s Position of %s to %s" % [
		"Local" if local else "Global",
		BBUtil.bb_var(target_var),
		BBUtil.bb_var(vector_var),
	]

func _tick(_delta: float) -> Status:
	var target = BBUtil.bb_value(target_var, blackboard)
	if not is_instance_valid(target):
		target = agent
	var new_position: Vector3
	if local:
		new_position = target.position
	else:
		new_position = target.global_position
	var vector = BBUtil.bb_value(vector_var, blackboard)
	if vector == null:
		return FAILURE
	new_position = vector
	if local:
		target.position = new_position
	else:
		target.global_position = new_position
	return SUCCESS
