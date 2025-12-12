@tool
extends BTAction

@export var target_position_var := &"target_position"
@export var time: float = 1
@export var delay: float
@export var transition_type := Tween.TransitionType.TRANS_LINEAR
@export var ease_type := Tween.EaseType.EASE_IN_OUT
@export var wait_for_finish: bool = true

@export var move_to_tween_var := &"move_to_tween"

var _move_to_tween: Tween
var _target_position: Vector3
var _tween_finished: bool

func _generate_name() -> String:
	return "Tween To Position " + LimboUtility.decorate_var(target_position_var)

func _enter() -> void:
	_target_position = blackboard.get_var(target_position_var)
	_tween_finished = false
	_move_to_tween = agent.create_tween()
	_move_to_tween.tween_property(agent, "global_position", _target_position, time) \
		.set_trans(transition_type) \
		.set_ease(ease_type) \
		.set_delay(delay)
	_move_to_tween.tween_callback(func():
		_tween_finished = true)
	blackboard.set_var(move_to_tween_var, _move_to_tween)

func _tick(_delta: float) -> Status:
	if _target_position == null:
		return FAILURE
	if _tween_finished or not wait_for_finish:
		return SUCCESS
	return RUNNING
