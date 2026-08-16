@tool
extends BTAction

@export var node_var := &"self"
## Blackboard variable that stores our target (expecting Node3D).
@export var target_var: StringName = &"target"
@export var face_x: bool
@export var face_y: bool = true
@export var face_z: bool

func _generate_name() -> String:
	return "Face %s to Target %s" % [
		LimboUtility.decorate_var(node_var),
		LimboUtility.decorate_var(target_var),
	]

func _tick(_delta: float) -> Status:
	var target: Node3D = blackboard.get_var(target_var)
	if not is_instance_valid(target):
		return FAILURE
	var node: Node3D = agent
	if blackboard.has_var(node_var):
		node = blackboard.get_var(node_var)
		if not is_instance_valid(node):
			node = agent
	node.look_at(target.global_position)
	if not face_x:
		node.global_rotation.x = 0
	if not face_y:
		node.global_rotation.y = 0
	if not face_z:
		node.global_rotation.z = 0
	return SUCCESS
