@tool
class_name ShakeObject extends BTAction

@export var shaker_component_var: BBVariant
@export var shake_amount_var: BBVariant
@export var shake_duration_var: BBVariant
@export var shake_in_place_var: BBVariant
@export var shake_taper_off_var: BBVariant

func _generate_name() -> String:
	return "Shake Object by %s for %s" % [
		BBUtil.bb_var(shake_amount_var),
		BBUtil.bb_var(shake_duration_var),
	]

func _tick(_delta: float) -> Status:
	var shaker_component = BBUtil.bb_value(shaker_component_var, blackboard)
	if not is_instance_valid(shaker_component):
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
	_do_shake(shaker_component, shake_amount, shake_duration, shake_in_place, shake_taper_off)
	return SUCCESS

func _do_shake(shaker_component: Shaker, shake_amount: float, shake_duration: float, shake_in_place: bool, shake_taper_off: bool) -> void:
	shaker_component.shake(shake_amount, shake_duration, shake_in_place, shake_taper_off)
