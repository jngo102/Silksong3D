@tool
extends BTAction

@export var canvas_item_var: BBVariant
@export var from_var: BBVariant
@export var to_var: BBVariant
@export var fade_time_var: BBVariant

func _generate_name() -> String:
	return "Fade %s from %s to %s for %s seconds" % [
		BBUtil.bb_var(canvas_item_var),
		BBUtil.bb_var(from_var),
		BBUtil.bb_var(to_var),
		BBUtil.bb_var(fade_time_var),
	]

func _tick(_delta: float) -> Status:
	var canvas_item: CanvasItem = BBUtil.bb_value(canvas_item_var, blackboard, agent)
	if canvas_item == null:
		return FAILURE
	var from: float = BBUtil.bb_value(from_var, blackboard, agent)
	if from == null:
		return FAILURE
	canvas_item.show()
	var to: float = BBUtil.bb_value(to_var, blackboard, agent)
	if to == null:
		return FAILURE
	var fade_time: float = BBUtil.bb_value(fade_time_var, blackboard, agent)
	if fade_time == null:
		return FAILURE
	var fade_tween: Tween = canvas_item.create_tween()
	fade_tween.tween_property(canvas_item, "modulate:a", to, fade_time).from(from)
	return SUCCESS
