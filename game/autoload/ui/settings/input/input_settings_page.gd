class_name InputSettingsPage extends Control

@onready var _contents: VBoxContainer = $Contents
@onready var _look_sensitivity_mouse_slider: SettingValueSlider = _contents.get_node_or_null("LookSensitivityMouse")
@onready var _look_sensitivity_joystick_slider: SettingValueSlider = _contents.get_node_or_null("LookSensitivityJoystick")
@onready var _invert_mouse_x_select: SettingSelectOption = _contents.get_node_or_null("InvertMouseX")
@onready var _invert_mouse_y_select: SettingSelectOption = _contents.get_node_or_null("InvertMouseY")
@onready var _invert_joystick_x_select: SettingSelectOption = _contents.get_node_or_null("InvertJoystickX")
@onready var _invert_joystick_y_select: SettingSelectOption = _contents.get_node_or_null("InvertJoystickY")
@onready var _rebinders_container: VBoxContainer = _contents.get_node_or_null("RebindersContainer")

var _input_rebinder_prefab: PackedScene = preload("uid://2at86fvhvt8v")

## Whether an input is currently being rebound
var rebinding: bool:
	get:
		return _rebinders_container.get_children().any(func(child: Node):
			if child is InputRebinder:
				return child.rebinding)

func _ready() -> void:
	InputHelper.device_changed.connect(_on_device_change)
	_on_device_change(InputHelper.device, InputHelper.device_index)
	_look_sensitivity_mouse_slider.slider_value = SaveManager.settings.look_sensitivity_mouse
	_look_sensitivity_joystick_slider.slider_value = SaveManager.settings.look_sensitivity_joystick
	_invert_mouse_x_select.current_option = SaveManager.settings.invert_mouse_x
	_invert_mouse_y_select.current_option = SaveManager.settings.invert_mouse_y
	_invert_joystick_x_select.current_option = SaveManager.settings.invert_joystick_x
	_invert_joystick_y_select.current_option = SaveManager.settings.invert_joystick_y
	for action in InputMap.get_actions().filter(func(action): return not action.contains("ui_")):
		var input_rebinder: InputRebinder = _input_rebinder_prefab.instantiate()
		input_rebinder.action_name = action
		_rebinders_container.add_child(input_rebinder)

func _on_device_change(device: String, _device_index: int) -> void:
	if InputManager.on_keys:
		_look_sensitivity_mouse_slider.show()
		_invert_mouse_x_select.show()
		_invert_mouse_y_select.show()
		_look_sensitivity_joystick_slider.hide()
		_invert_joystick_x_select.hide()
		_invert_joystick_y_select.hide()
	else:
		_look_sensitivity_mouse_slider.hide()
		_invert_mouse_x_select.hide()
		_invert_mouse_y_select.hide()
		_look_sensitivity_joystick_slider.show()
		_invert_joystick_x_select.show()
		_invert_joystick_y_select.show()


func _on_look_sensitivity_mouse_value_changed(new_value: float) -> void:
	SaveManager.settings.look_sensitivity_mouse = new_value

func _on_look_sensitivity_joystick_value_changed(new_value: float) -> void:
	SaveManager.settings.look_sensitivity_joystick = new_value

func _on_invert_mouse_x_value_changed(new_value: bool) -> void:
	SaveManager.settings.invert_mouse_x = new_value

func _on_invert_mouse_y_value_changed(new_value: bool) -> void:
	SaveManager.settings.invert_mouse_y = new_value

func _on_invert_joystick_x_value_changed(new_value: bool) -> void:
	SaveManager.settings.invert_joystick_x = new_value

func _on_invert_joystick_y_value_changed(new_value: bool) -> void:
	SaveManager.settings.invert_joystick_y = new_value
