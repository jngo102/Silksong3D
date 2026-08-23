@tool
extends BTAction

@export var node_var: BBVariant
@export var signal_name: StringName

var _signal_emitted: bool

func _generate_name() -> String:
	return "Await Signal \"%s\" of Node %s" % [signal_name, BBUtil.bb_var(node_var)]

func _enter() -> void:
	_signal_emitted = false
	var node: Node = BBUtil.bb_value(node_var, blackboard, agent)
	if is_instance_valid(node) and not node.is_connected(signal_name, _on_signal_emitted):
		node.connect(signal_name, _on_signal_emitted)

func _on_signal_emitted() -> void:
	_signal_emitted = true

func _tick(_delta: float) -> Status:
	if _signal_emitted:
		_signal_emitted = false
		return SUCCESS
	return RUNNING
