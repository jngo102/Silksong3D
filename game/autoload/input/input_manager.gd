## Manager of player input
extends Node

## Reference to parent of all input actions
@onready var input_actions: Node = $InputActions

## Mappings from action names to their input actions
var action_map: Dictionary:
	get:
		var map: Dictionary = {}
		var actions = input_actions.get_children()
		for action in actions:
			map[action.action_name] = action
		return map

## Whether the player is using keyboard/mouse
var on_keys: bool:
	get:
		return InputHelper.device == InputHelper.DEVICE_KEYBOARD

## Whether the player is using a game controller
var on_joypad: bool:
	get:
		return not on_keys

func _ready() -> void:
	var input_json: String = SaveManager.settings.serialized_input
	if len(input_json) > 0:
		InputHelper.deserialize_inputs_for_actions(input_json)

func _exit_tree() -> void:
	SaveManager.settings.serialized_input = InputHelper.serialize_inputs_for_actions()

## Check whether an input action is buffered
func is_buffered(action_name: StringName) -> bool:
	return action_map[action_name].is_buffered
