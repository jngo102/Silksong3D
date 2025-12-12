@tool
extends BTAction

@export var tween_var := &"tween"

func _generate_name() -> String:
	return "Kill Tween " + LimboUtility.decorate_var(tween_var)

func _tick(_delta: float) -> Status:
	var tween: Tween = blackboard.get_var(tween_var)
	if is_instance_valid(tween):
		tween.kill()
	return SUCCESS
