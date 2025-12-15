@tool
extends BTAction

@export var vector_var := &"vector"
@export var x_var: BBVariant
@export var y_var: BBVariant
@export var z_var: BBVariant

func _generate_name() -> String:
	return "Set Components of Vector %s→(%s, %s, %s)" % [
		LimboUtility.decorate_var(vector_var),
		BBUtil.bb_var(x_var),
		BBUtil.bb_var(y_var),
		BBUtil.bb_var(z_var),
	]

func _tick(_delta: float) -> Status:
	if not blackboard.has_var(vector_var):
		return FAILURE
	var vector: Vector3 = blackboard.get_var(vector_var)
	var x = BBUtil.bb_value(x_var, blackboard)
	if x != null:
		vector.x = x
	var y = BBUtil.bb_value(y_var, blackboard)
	if y != null:
		vector.y = y
	var z = BBUtil.bb_value(z_var, blackboard)
	if z != null:
		vector.z = z
	blackboard.set_var(vector_var, vector)
	return SUCCESS
