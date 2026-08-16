@tool
class_name QueueFree extends BTAction

@export var object_to_free_var: BBVariant

func _generate_name() -> String:
	return "Free Object " + BBUtil.bb_var(object_to_free_var)

func _tick(_delta: float) -> Status:
	var object_to_free = BBUtil.bb_value(object_to_free_var, blackboard, agent)
	if object_to_free == null:
		return FAILURE
	object_to_free.queue_free()
	return SUCCESS
