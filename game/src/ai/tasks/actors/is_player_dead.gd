@tool
extends BTAction

func _generate_name() -> String:
	return "Check If Player Is Dead"

func _tick(_delta: float) -> Status:
	var player: Player = agent.get_tree().get_first_node_in_group(&"Players")
	if not is_instance_valid(player):
		return SUCCESS
	elif player.health.is_dead:
		return SUCCESS
	return FAILURE
