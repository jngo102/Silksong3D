@tool
extends Node

func bb_var(param: BBVariant, output: bool = false) -> String:
	if param.value_source == BBParam.ValueSource.SAVED_VALUE:
		if param.saved_value == null:
			return "?"
		return str(param.saved_value)
	elif param.value_source == BBParam.ValueSource.BLACKBOARD_VAR:
		if output:
			return LimboUtility.decorate_output_var(param.variable)
		else:
			return LimboUtility.decorate_var(param.variable)
	return "?"

func bb_value(param: BBVariant, blackboard: Blackboard) -> Variant:
	if param == null:
		return null
	elif param.value_source == BBParam.ValueSource.SAVED_VALUE:
		if param.saved_value == null:
			return null
		return param.saved_value
	elif param.value_source == BBParam.ValueSource.BLACKBOARD_VAR:
		return blackboard.get_var(param.variable)
	return null
