@tool
extends BTAction

@export var node_var: BBVariant
## Blackboard variable that stores our target (expecting Node3D).
@export var target_var: BBVariant
@export var face_x: bool
@export var face_y: bool = true
@export var face_z: bool

func _generate_name() -> String:
	return "Face %s to Target %s" % [
		BBUtil.bb_var(node_var),
		BBUtil.bb_var(target_var),
	]

func _tick(_delta: float) -> Status:
	var target = BBUtil.bb_value(target_var, blackboard, agent)
	if not is_instance_valid(target):
		return FAILURE
	var node: Node3D = BBUtil.bb_value(node_var, blackboard, agent)
	if not is_instance_valid(node):
		node = agent
	var old_x: float = node.global_rotation.x
	var old_y: float = node.global_rotation.y
	var old_z: float = node.global_rotation.z
	if not is_equal_approx(node.global_position.distance_to(target.global_position), 0):
		node.look_at(target.global_position)
	if not face_x:
		node.global_rotation.x = old_x
	if not face_y:
		node.global_rotation.y = old_y
	if not face_z:
		node.global_rotation.z = old_z
	return SUCCESS
