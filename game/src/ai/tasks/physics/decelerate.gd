@tool
extends BTAction

## Blackboard variable that stores our target (expecting Node3D).
@export var deceleration_time: float = 1

var _initial_speed: float

func _generate_name() -> String:
	return "Decelerate In %s Seconds" % deceleration_time

func _enter() -> void:
	_initial_speed = agent.velocity.length()

func _tick(delta: float) -> Status:
	if agent is CharacterBody3D:
		var direction: Vector3 = agent.velocity.normalized()
		var current_speed: float = agent.velocity.length()
		var next_speed: float = current_speed - _initial_speed / deceleration_time * delta
		agent.velocity = direction * next_speed
		if next_speed <= 0:
			return SUCCESS
		return RUNNING
	return FAILURE
