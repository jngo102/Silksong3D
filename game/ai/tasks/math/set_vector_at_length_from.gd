@tool
extends BTAction

@export var start_var: BBVariant
@export var direction_var: BBVariant
@export var length_var: BBVariant

@export var output_vector_var := &"output_vector"

func _generate_name() -> String:
	return "Set Vector From %s In Direction of %s with Length %s%s" % [
		BBUtil.bb_var(start_var),
		BBUtil.bb_var(direction_var),
		BBUtil.bb_var(length_var),
		LimboUtility.decorate_output_var(output_vector_var),
	]

func _tick(_delta: float) -> Status:
	var start_vector = BBUtil.bb_value(start_var, blackboard)
	if start_vector == null:
		return FAILURE
	var direction = BBUtil.bb_value(direction_var, blackboard)
	if direction == null:
		return FAILURE
	var length = BBUtil.bb_value(length_var, blackboard)
	if length == null:
		return FAILURE
	var output_vector: Vector3 = start_vector + direction.normalized() * length
	blackboard.set_var(output_vector_var, output_vector)
	return SUCCESS
