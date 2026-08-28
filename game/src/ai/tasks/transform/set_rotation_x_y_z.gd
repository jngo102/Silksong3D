@tool
extends BTAction

@export var target_var: BBVariant
@export var x_var: BBVariant
@export var y_var: BBVariant
@export var z_var: BBVariant
@export var local: bool

func _generate_name() -> String:
	return "Set %s Rotation of %s to (%s, %s, %s)" % [
		"Local" if local else "Global",
		BBUtil.bb_var(target_var),
		BBUtil.bb_var(x_var),
		BBUtil.bb_var(y_var),
		BBUtil.bb_var(z_var),
	]

func _tick(_delta: float) -> Status:
	var target = BBUtil.bb_value(target_var, blackboard, agent)
	if target == null:
		target = agent
	var new_rotation: Vector3
	if local:
		new_rotation = target.rotation_degrees
	else:
		new_rotation = target.global_rotation_degrees
	var x = BBUtil.bb_value(x_var, blackboard, agent)
	if x != null:
		new_rotation.x = x
	var y = BBUtil.bb_value(y_var, blackboard, agent)
	if y != null:
		new_rotation.y = y
	var z = BBUtil.bb_value(z_var, blackboard, agent)
	if z != null:
		new_rotation.z = z
	if local:
		target.rotation_degrees = new_rotation
	else:
		target.global_rotation_degrees = new_rotation
	return SUCCESS
