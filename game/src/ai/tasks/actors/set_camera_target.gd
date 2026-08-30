@tool
class_name ShakeCamera extends BTAction

@export var target_var: BBVariant
@export var with_offset_var: BBVariant

func _generate_name() -> String:
	return "Set Camera Target to %s with offset %s" % [
		BBUtil.bb_var(target_var),
		BBUtil.bb_var(with_offset_var),
	]

func _tick(_delta: float) -> Status:
	if not is_instance_valid(CameraManager.current_camera):
		return FAILURE
	var target = BBUtil.bb_value(target_var, blackboard, agent)
	if target == null or target is not Node3D:
		return FAILURE
	var camera: CameraController = CameraManager.current_camera
	camera.set_target(target)
	var offset = BBUtil.bb_value(with_offset_var, blackboard, agent)
	if offset != null and offset is Vector3:
		camera.set_offset(offset)
	return SUCCESS
