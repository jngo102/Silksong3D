@tool
extends BTAction

@export var target_var: BBVariant
@export var x_var: BBVariant
@export var y_var: BBVariant
@export var z_var: BBVariant

func _generate_name() -> String:
	return "Translate %s by (%s, %s, %s)" % [
		BBUtil.bb_var(target_var),
		BBUtil.bb_var(x_var),
		BBUtil.bb_var(y_var),
		BBUtil.bb_var(z_var),
	]

func _tick(_delta: float) -> Status:
	var target = BBUtil.bb_value(target_var, blackboard, agent)
	if not is_instance_valid(target):
		target = agent
	var new_position: Vector3
	var x = BBUtil.bb_value(x_var, blackboard, agent)
	if x != null:
		target.position.x += x
	var y = BBUtil.bb_value(y_var, blackboard, agent)
	if y != null:
		target.position.y += y
	var z = BBUtil.bb_value(z_var, blackboard, agent)
	if z != null:
		target.position.z += z
	return SUCCESS
