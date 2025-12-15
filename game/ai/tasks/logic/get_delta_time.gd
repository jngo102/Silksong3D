@tool
extends BTAction

@export var output_delta_var := &"delta_time"

func _generate_name() -> String:
	return "Get Delta Time%s" % [
		LimboUtility.decorate_output_var(output_delta_var),
	]

func _tick(_delta: float) -> Status:
	var delta_time: float = agent.get_process_delta_time()
	blackboard.set_var(output_delta_var, delta_time)
	return SUCCESS
