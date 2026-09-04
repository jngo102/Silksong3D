## UI for rebinding an input action
class_name InputRebinder extends HBoxContainer

## The maximum amount of characters that a rebinding button can have.
const UNBOUND_TEXT: String = "None"

## The name of the input action that this UI will rebind
var action_name: StringName
## Label for displaying the input action's name
@onready var _action_label: Label = $ActionLabel
## Button to begin rebinding an input action
@onready var _rebind_button: Button = $RebindButton

signal rebound()

## Whether the input action is currently being rebound
var rebinding: bool:
	set(value):
		rebinding = value
		if value:
			_rebind_button.text = "Listening..."
		else:
			update_device_labels()

func _ready() -> void:
	_action_label.text = action_name
	InputHelper.device_changed.connect(update_device_labels)
	update_device_labels()

func _input(event: InputEvent) -> void:
	if not rebinding or not event.is_pressed():
		return
	if event.is_action_pressed(&"ui_cancel"):
		_end_rebind()
		return
	if (InputManager.on_keys and not event is InputEventKey and not event is InputEventMouseButton) or \
		(InputManager.on_joypad and not event is InputEventJoypadButton and not event is InputEventJoypadMotion):
		return
	if rebinding:
		rebind(event)

## Rebind a joystick or joypad button on a game controllerr
func rebind(input: InputEvent) -> void:
	if input is InputEventKey or input is InputEventMouseButton:
		var current_binding: InputEvent = InputHelper.get_keyboard_input_for_action(action_name)
		if InputHelper.set_keyboard_input_for_action(action_name, input, false) != OK:
			push_error("Failed to set keyboard input for action \"", action_name, "\" to ", input)
			return
		for action in InputManager.gameplay_actions:
			if action != action_name and input.is_action(action):
				if InputHelper.set_keyboard_input_for_action(action, current_binding, false) != OK:
					push_error("Failed to swap keyboard input for action \"", action, "\" to ", current_binding)
					return
				break
	elif input is InputEventJoypadButton or input is InputEventJoypadMotion:
		var current_binding: InputEvent = InputHelper.get_joypad_input_for_action(action_name)
		if InputHelper.set_joypad_input_for_action(action_name, input, false) != OK:
			push_error("Failed to set joypad input for action \"", action_name, "\" to ", input)
			return
		for action in InputManager.gameplay_actions:
			if action != action_name and input.is_action(action):
				if InputHelper.set_joypad_input_for_action(action, current_binding, false) != OK:
					push_error("Failed to swap keyboard input for action \"", action, "\" to ", current_binding)
					return
				break
	_end_rebind()
	rebound.emit()

## Cancel the current rebind process
func _end_rebind() -> void:
	accept_event()
	rebinding = false
	_rebind_button.grab_focus()

func update_device_labels(device: String = InputHelper.device, _device_index: int = 0) -> void:
	if InputManager.on_keys:
		var key_mouse_input: InputEvent = InputHelper.get_keyboard_input_for_action(action_name)
		if key_mouse_input is InputEventKey:
			var keycode: Key = key_mouse_input.physical_keycode
			if keycode == Key.KEY_NONE:
				keycode = key_mouse_input.keycode
			_rebind_button.text = OS.get_keycode_string(DisplayServer.keyboard_get_label_from_physical(keycode))
		elif key_mouse_input is InputEventMouseButton:
			var button_index: MouseButton = key_mouse_input.button_index
			match button_index:
				MOUSE_BUTTON_WHEEL_UP, \
				MOUSE_BUTTON_WHEEL_DOWN, \
				MOUSE_BUTTON_WHEEL_LEFT, \
				MOUSE_BUTTON_WHEEL_RIGHT:
					button_index = MOUSE_BUTTON_MIDDLE
			_rebind_button.text = InputHelper.get_label_for_input(key_mouse_input)
	else:
		var joypad_input: InputEvent = InputHelper.get_joypad_input_for_action(action_name)
		_rebind_button.text = InputHelper.get_label_for_input(joypad_input)

func _on_rebind_button_pressed() -> void:
	rebinding = true
	_rebind_button.release_focus()

func _on_focus_entered() -> void:
	_rebind_button.grab_focus()
