@tool
extends BTAction

@export var roar_position_var: BBVariant

@export var output_roar_effect_var := &"roar_effect"

var roar_scene: PackedScene = preload("uid://2s4q3xkx51ig")

func _generate_name() -> String:
	return "Create Roar Effect at " + BBUtil.bb_var(roar_position_var)

func _tick(_delta: float) -> Status:
	var roar_effect: Node3D = roar_scene.instantiate()
	agent.add_child(roar_effect)
	if not is_instance_valid(roar_effect):	
		return FAILURE
	var roar_position = BBUtil.bb_value(roar_position_var, blackboard)
	if roar_position != null:
		roar_effect.global_position = roar_position
	else:
		roar_effect.global_position = agent.global_position
	blackboard.set_var(output_roar_effect_var, roar_effect)
	return SUCCESS
