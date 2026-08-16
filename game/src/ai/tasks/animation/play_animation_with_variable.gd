@tool
extends BTPlayAnimation

@export var animation_var := &""
@export var wait_for_finish: bool

var _animator: AnimationPlayer
var _anim_name: StringName
var _anim_finished: bool

func _generate_name() -> String:
	return "Play Animation With Variable %s" % LimboUtility.decorate_var(animation_var)

func _enter() -> void:
	_anim_finished = false
	_animator = animation_player.get_value(agent, blackboard)
	if is_instance_valid(_animator):
		_anim_name = blackboard.get_var(animation_var)
		if _anim_name != null:
			_animator.play(_anim_name, blend, speed, from_end)
			if wait_for_finish:
				if not _animator.animation_finished.is_connected(_on_animator_finish):
					_animator.animation_finished.connect(_on_animator_finish)

func _exit() -> void:
	if _animator.animation_finished.is_connected(_on_animator_finish):
		_animator.animation_finished.disconnect(_on_animator_finish)

func _tick(_delta: float) -> Status:
	if is_instance_valid(_animator):
		if _anim_finished or not wait_for_finish:
			return SUCCESS
		return RUNNING
	return FAILURE

func _on_animator_finish(anim_name: StringName) -> void:
	if anim_name == _anim_name:
		_anim_finished = true
