@tool
extends BTAction

@export var target_var: BBVariant
@export var output_x_var := &"rotation_x"
@export var output_y_var := &"rotation_y"
@export var output_z_var := &"rotation_z"
@export var degrees: bool = true
@export var local: bool

func _generate_name() -> String:
	return "Get %s Rotation of %s in %s -> (%s, %s, %s)" % [
		"Local" if local else "Global",
		BBUtil.bb_var(target_var),
		"Degrees" if degrees else "Radians",
		LimboUtility.decorate_var(output_x_var),
		LimboUtility.decorate_var(output_y_var),
		LimboUtility.decorate_var(output_z_var),
	]

func _tick(_delta: float) -> Status:
	var target: Node3D = BBUtil.get_value(target_var)
	if not is_instance_valid(target):
		target = agent
	var current_rotation: Vector3
	if local:
		current_rotation = target.rotation_degrees
	else:
		current_rotation = target.global_rotation_degrees
	if blackboard.has_var(output_x_var):
		blackboard.set_var(output_x_var, current_rotation.x)
	if blackboard.has_var(output_y_var):
		blackboard.set_var(output_y_var, current_rotation.x)
	if blackboard.has_var(output_z_var):
		blackboard.set_var(output_z_var, current_rotation.x)
	return SUCCESS
