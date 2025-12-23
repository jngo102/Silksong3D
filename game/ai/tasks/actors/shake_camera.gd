@tool
class_name ShakeCamera extends BTAction

@export var shake_amount_var: BBVariant
@export var shake_duration_var: BBVariant
@export var shake_in_place_var: BBVariant
@export var shake_taper_off_var: BBVariant

func _generate_name() -> String:
	return "Shake Camera by %s for %ss" % [
		BBUtil.bb_var(shake_amount_var),
		BBUtil.bb_var(shake_duration_var),
	]

func _tick(_delta: float) -> Status:
	if not is_instance_valid(CameraManager.current_camera):
		return FAILURE
	var shake_amount = BBUtil.bb_value(shake_amount_var, blackboard)
	if shake_amount == null:
		shake_amount = 0
	var shake_duration = BBUtil.bb_value(shake_duration_var, blackboard)
	if shake_duration == null:
		shake_duration = 0
	var shake_in_place = BBUtil.bb_value(shake_in_place_var, blackboard)
	if shake_in_place == null:
		shake_in_place = true
	var shake_taper_off = BBUtil.bb_value(shake_taper_off_var, blackboard)
	if shake_taper_off == null:
		shake_taper_off = false
	var camera: GameCamera = scene_root.get_viewport().get_camera_3d()
	camera.shake(shake_amount, shake_duration, shake_in_place, shake_taper_off)
	return SUCCESS
