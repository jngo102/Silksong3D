class_name InputPrompt extends Control

@export var action: StringName

@onready var _input_icon: Button = $InputIcon

func _ready() -> void:
	if InputManager.on_keys:
		var key_mouse_input: InputEvent = InputHelper.get_keyboard_input_for_action("Bind")
		if key_mouse_input is InputEventKey:
			_input_icon.text = OS.get_keycode_string(key_mouse_input.keycode)
		elif key_mouse_input is InputEventMouseButton:
			var button_index: MouseButton = key_mouse_input.button_index
			match button_index:
				MOUSE_BUTTON_WHEEL_UP, \
				MOUSE_BUTTON_WHEEL_DOWN, \
				MOUSE_BUTTON_WHEEL_DOWN, \
				MOUSE_BUTTON_WHEEL_RIGHT:
					button_index = MOUSE_BUTTON_MIDDLE
			_input_icon.text = InputHelper.get_label_for_input(key_mouse_input)
	else:
		var joypad_input: InputEvent = InputHelper.get_joypad_input_for_action("Bind")
		_input_icon.text = InputHelper.get_label_for_input(joypad_input)
