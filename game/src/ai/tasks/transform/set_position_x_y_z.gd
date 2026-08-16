@tool
extends BTAction

@export var target_var := &"target"
@export var x_var: BBVariant
@export var y_var: BBVariant
@export var z_var: BBVariant
@export var local: bool

func _generate_name() -> String:
	return "Set %s Position of %s to (%s, %s, %s)" % [
		"Local" if local else "Global",
		LimboUtility.decorate_var(target_var),
		BBUtil.bb_var(x_var),
		BBUtil.bb_var(y_var),
		BBUtil.bb_var(z_var),
	]

func _tick(_delta: float) -> Status:
	var target: Node3D = blackboard.get_var(target_var)
	if not is_instance_valid(target):
		target = agent
	var new_position: Vector3
	if local:
		new_position = target.position
	else:
		new_position = target.global_position
	var x = BBUtil.bb_value(x_var, blackboard)
	if x != null:
		new_position.x = x
	var y = BBUtil.bb_value(y_var, blackboard)
	if y != null:
		new_position.y = y
	var z = BBUtil.bb_value(z_var, blackboard)
	if z != null:
		new_position.z = z
	if local:
		target.position = new_position
	else:
		target.global_position = new_position
	return SUCCESS
