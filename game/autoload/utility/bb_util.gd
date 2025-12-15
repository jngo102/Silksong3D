@tool
extends Node

func bb_var(param: BBVariant, output: bool = false) -> String:
	if param == null:
		return "?"
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

func bb_value(param: BBVariant, blackboard: Blackboard, root_node_path = null) -> Variant:
	if param == null:
		return null
	elif param.value_source == BBParam.ValueSource.SAVED_VALUE:
		match param.type:
			Variant.Type.TYPE_NIL:
				return null
			Variant.Type.TYPE_NODE_PATH:
				if root_node_path != null:
					return root_node_path.get_node_or_null(param.saved_value)
		return param.saved_value
	elif param.value_source == BBParam.ValueSource.BLACKBOARD_VAR:
		return blackboard.get_var(param.variable)
	return null
