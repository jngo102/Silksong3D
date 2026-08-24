@tool
extends BTAction

@export var area_var: BBVariant
@export var check_areas: bool = true
@export var check_bodies: bool = true

func _generate_name() -> String:
	return "Check " + BBUtil.bb_var(area_var) + " Colliding"

func _tick(_delta: float) -> Status:
	var area = BBUtil.bb_value(area_var, blackboard, agent)
	if area is Area3D:
		if (check_areas and area.has_overlapping_areas()) or \
		   (check_bodies and area.has_overlapping_bodies()):
			return SUCCESS
	return FAILURE
