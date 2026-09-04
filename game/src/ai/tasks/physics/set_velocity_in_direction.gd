@tool
extends BTAction

@export var direction_var: StringName = &""

@export var speed: float
@export var face_velocity: bool = true

func _generate_name() -> String:
	return "Set Velocity In Direction %s with Speed %s" % [LimboUtility.decorate_var(direction_var), str(speed)]

func _tick(_delta: float) -> Status:
	var direction: Vector3 = blackboard.get_var(direction_var)
	if direction == null:
		return FAILURE
	if agent is CharacterBody3D:
		var velocity: Vector3 = direction.normalized() * speed
		if face_velocity and velocity.length() > 0:
			agent.look_at(agent.global_position + velocity)
		agent.velocity = velocity
		return SUCCESS
	return FAILURE
