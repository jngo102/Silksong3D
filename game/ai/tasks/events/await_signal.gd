@tool
extends BTAction

@export var node_var := &"node"
@export var signal_name: StringName

var _signal_emitted: bool

func _generate_name() -> String:
	return "Await Signal \"%s\" in Node %s" % [signal_name, LimboUtility.decorate_var(node_var)]

func _setup() -> void:
	var node: Node = blackboard.get_var(node_var)
	if is_instance_valid(node) and not node.is_connected(signal_name, _on_signal_emitted):
		node.connect(signal_name, _on_signal_emitted)

func _enter() -> void:
	_signal_emitted = false

func _on_signal_emitted() -> void:
	_signal_emitted = true

func _tick(_delta: float) -> Status:
	if _signal_emitted:
		_signal_emitted = false
		return SUCCESS
	return RUNNING
