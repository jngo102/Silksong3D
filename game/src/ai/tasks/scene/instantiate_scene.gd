@tool
extends BTAction

@export var scene_to_instantiate_var: BBVariant
@export var get_node_path: bool
@export var output_var := &"instantiated_scene"

func _generate_name() -> String:
	return "Instantiate Scene " + BBUtil.bb_var(scene_to_instantiate_var) + LimboUtility.decorate_output_var(output_var)

func _tick(_delta: float) -> Status:
	var scene_to_instantiate = BBUtil.bb_value(scene_to_instantiate_var, blackboard, agent)
	if scene_to_instantiate == null:
		return FAILURE
	var instance = scene_to_instantiate.instantiate()
	if is_instance_valid(instance):
		if is_instance_valid(agent.owner):
			agent.owner.add_child(instance)
		else:
			agent.add_child(instance)
		if blackboard.has_var(output_var):
			if get_node_path:
				blackboard.set_var(output_var, instance.get_path())
			else:
				blackboard.set_var(output_var, instance)
			return SUCCESS
	return FAILURE
