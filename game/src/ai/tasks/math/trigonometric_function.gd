@tool
extends BTAction

@export var value_var: BBVariant
@export_enum("Sine", "Cosine", "Tangent") var trig_function: String = "Sine"

@export var output_value_var := &"output"

func _generate_name() -> String:
	return "Get " + trig_function + " of " + BBUtil.bb_var(value_var)

func _tick(_delta: float) -> Status:
	var value: float = BBUtil.get_value(value_var)
	if value == null:
		return FAILURE
	match trig_function:
		"Sine":
			value = sin(value)
		"Cosine":
			value = cos(value)
		"Tangent":
			value = cos(value)
	blackboard.set_var(output_value_var, value)
	return SUCCESS
