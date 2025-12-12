@tool
class_name ShakeCamera extends ShakeObject

func _generate_name() -> String:
	return "Shake Camera by %s for %ss" % [
		BBUtil.bb_var(shake_amount_var),
		BBUtil.bb_var(shake_duration_var),
	]

func _tick(_delta: float) -> Status:
	var camera_shaker: Shaker = scene_root.get_tree().get_first_node_in_group("Cameras").get_node("../../Shaker")
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
	_do_shake(camera_shaker, shake_amount, shake_duration, shake_in_place, shake_taper_off)
	return SUCCESS
