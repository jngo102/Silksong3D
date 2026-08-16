@tool
extends BTAction

@export var collider_var: BBVariant

@export var enabled: bool

func _generate_name() -> String:
	return "Set Collider " + ("Enabled" if enabled else "Disabled")

func _tick(_delta: float) -> Status:
	var collider = BBUtil.bb_value(collider_var, blackboard, agent)
	if collider == null:
		return FAILURE
	collider.disabled = not enabled
	return SUCCESS
