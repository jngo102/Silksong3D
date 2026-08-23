@tool
extends BTAction

@export var target_var := &"target"
@export var local: bool

@export var output_x_var := &"x"
@export var output_y_var := &"y"
@export var output_z_var := &"z"

func _generate_name() -> String:
	return "Get Position of %s->(%s, %s, %s)" % [
		LimboUtility.decorate_var(target_var),
		LimboUtility.decorate_var(output_x_var),
		LimboUtility.decorate_var(output_y_var),
		LimboUtility.decorate_var(output_z_var),
	]

func _tick(_delta: float) -> Status:
	var target: Node3D = blackboard.get_var(target_var)
	if not is_instance_valid(target):
		target = agent
	var position: Vector3 = target.global_position
	if local:
		position = target.position
	if blackboard.has_var(output_x_var):
		blackboard.set_var(output_x_var, position.x)
	if blackboard.has_var(output_y_var):
		blackboard.set_var(output_y_var, position.y)
	if blackboard.has_var(output_z_var):
		blackboard.set_var(output_z_var, position.z)
	return SUCCESS
