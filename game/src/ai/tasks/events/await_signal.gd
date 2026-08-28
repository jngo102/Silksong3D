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
	var arg_count: int = 0
	var signals = node.get_signal_list()
	for node_signal in signals:
		if node_signal["name"] == signal_name:
			arg_count = node_signal["args"].size()
	var unbound_func: Callable = _on_signal_emitted
	if arg_count >= 1:
		unbound_func = unbound_func.unbind(arg_count)
	if is_instance_valid(node) and not node.is_connected(signal_name, unbound_func):
		node.connect(signal_name, unbound_func)

func _on_signal_emitted() -> void:
	_signal_emitted = true

func _tick(_delta: float) -> Status:
	if _signal_emitted:
		_signal_emitted = false
		return SUCCESS
	return RUNNING
