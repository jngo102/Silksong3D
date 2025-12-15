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

## Whether the input action is currently being rebound
var rebinding: bool:
	set(value):
		rebinding = value
		if value:
			_rebind_button.icon = null
			_rebind_button.text = "Listening..."
		else:
			_update_device_icons()

func _ready() -> void:
	_action_label.text = action_name
	InputHelper.device_changed.connect(_update_device_icons)
	_update_device_icons()

func _unhandled_input(event: InputEvent) -> void:
	if not rebinding or not event.is_pressed():
		return
	if event.is_action_pressed(&"ui_cancel") or event.is_action_pressed(&"ui_back"):
		cancel_rebind()
		return
	if (InputManager.on_keys and not event is InputEventKey and not event is InputEventMouseButton) or \
		(InputManager.on_joypad and not event is InputEventJoypadButton):
		return
	if rebinding:
		rebind(event)
	cancel_rebind()

## Rebind a joystick or joypad button on a game controllerr
func rebind(input: InputEvent) -> void:
	if input is InputEventKey or input is InputEventMouseButton:
		if InputHelper.set_keyboard_input_for_action(action_name, input) != OK:
			printerr("Failed to set keyboard input for action \"", action_name, "\" to ", input)
	elif input is InputEventJoypadButton:
		if InputHelper.set_joypad_input_for_action(action_name, input) != OK:
			printerr("Failed to set joypad input for action \"", action_name, "\" to ", input)
	_update_device_icons()

## Cancel the current rebind process
func cancel_rebind() -> void:
	accept_event()
	rebinding = false
	_rebind_button.grab_focus()

func _update_device_icons(device: String = InputHelper.device, _device_index: int = 0) -> void:
	if InputManager.on_keys:
		var key_mouse_input: InputEvent = InputHelper.get_keyboard_input_for_action(action_name)
		if key_mouse_input is InputEventKey:
			_rebind_button.icon = null
			_rebind_button.text = OS.get_keycode_string(key_mouse_input.physical_keycode)
		elif key_mouse_input is InputEventMouseButton:
			_rebind_button.icon = InputManager.current_input_icons[key_mouse_input.button_index]
			_rebind_button.text = ""
	else:
		var joypad_input: InputEvent = InputHelper.get_joypad_input_for_action(action_name)
		if joypad_input is InputEventJoypadButton:
			_rebind_button.icon = InputManager.current_input_icons[joypad_input.button_index]
		_rebind_button.text = ""

func _on_rebind_button_pressed() -> void:
	rebinding = true
	_rebind_button.release_focus()

func _on_focus_entered() -> void:
	_rebind_button.grab_focus()
