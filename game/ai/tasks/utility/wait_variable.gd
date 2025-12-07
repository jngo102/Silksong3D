@tool
extends BTRandomWait

@export var min_duration_var := &"min_time"
@export var max_duration_var := &"max_time"

var _wait_duration: float
var _current_time: float

func _generate_name() -> String:
	return "Wait For %s to %s seconds" % [
		LimboUtility.decorate_var(min_duration_var),
		LimboUtility.decorate_var(max_duration_var),
	]

func _enter() -> void:
	_current_time = 0
	var min_duration: float = blackboard.get_var(min_duration_var, 0)
	var max_duration: float = blackboard.get_var(max_duration_var, 0)
	_wait_duration = randf_range(min_duration, max_duration)

func _tick(delta: float) -> Status:
	_current_time += delta
	if _current_time >= _wait_duration:
		return SUCCESS
	return RUNNING
