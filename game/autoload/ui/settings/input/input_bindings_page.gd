class_name InputBindingsPage extends SettingsPage

## The input rebinder prefab to spawn for each input binding
@export var _input_rebinder_prefab: PackedScene

@onready var _rebinders_container: VBoxContainer = $RebindersContainer

## Whether an input is currently being rebound
var rebinding: bool:
	get:
		return _rebinders_container.get_children().any(func(child: Node):
			if child is InputRebinder:
				return child.rebinding)

func _ready() -> void:
	super._ready()
	for action in InputMap.get_actions().filter(func(action): return not action.contains("ui_")):
		var input_rebinder: InputRebinder = _input_rebinder_prefab.instantiate()
		input_rebinder.action_name = action
		_rebinders_container.add_child(input_rebinder)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_back"):
		hide()

func focus(child_index: int) -> void:
	_rebinders_container.get_child(child_index).grab_focus()
