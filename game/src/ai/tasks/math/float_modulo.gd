@tool
extends BTAction

@export var value_var := &"value"
@export var modulo_value_var := &"modulo_value"

func _generate_name() -> String:
	return "Float Modulo %s %%= %s" % [
		LimboUtility.decorate_var(value_var),
		LimboUtility.decorate_var(modulo_value_var),
	]

func _tick(_delta: float) -> Status:
	var value: float = blackboard.get_var(value_var)
	if value == null:
		return FAILURE
	var modulo_value: float = blackboard.get_var(modulo_value_var)
	if modulo_value == null:
		return FAILURE
	blackboard.set_var(value_var, fmod(value, modulo_value))
	return SUCCESS
