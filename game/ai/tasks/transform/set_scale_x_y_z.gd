@tool
extends BTAction

@export var target_var := &"target"
@export var x_var: BBVariant
@export var y_var: BBVariant
@export var z_var: BBVariant
@export var local: bool

func _generate_name() -> String:
	return "Set %s Scale of %s to (%s, %s, %s)" % [
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
	var new_scale: Vector3
	if local:
		new_scale = target.scale
	else:
		new_scale = target.scale
	var x = BBUtil.bb_value(x_var, blackboard)
	if x != null:
		new_scale.x = x
	var y = BBUtil.bb_value(y_var, blackboard)
	if y != null:
		new_scale.y = y
	var z = BBUtil.bb_value(z_var, blackboard)
	if z != null:
		new_scale.z = z
	if local:
		target.scale = new_scale
	else:
		target.scale = new_scale
	return SUCCESS
