class_name InputSettingsPage extends StackableUI

@onready var _settings_container: VBoxContainer = $SettingsContainer
@onready var _look_sensitivity_mouse_slider: SettingValueSlider = _settings_container.get_node_or_null("LookSensitivityMouse")
@onready var _look_sensitivity_joystick_slider: SettingValueSlider = _settings_container.get_node_or_null("LookSensitivityJoystick")
@onready var _invert_mouse_x_select: SettingSelectOption = _settings_container.get_node_or_null("InvertMouseX")
@onready var _invert_mouse_y_select: SettingSelectOption = _settings_container.get_node_or_null("InvertMouseY")
@onready var _invert_joystick_x_select: SettingSelectOption = _settings_container.get_node_or_null("InvertJoystickX")
@onready var _invert_joystick_y_select: SettingSelectOption = _settings_container.get_node_or_null("InvertJoystickY")
@onready var _bindings_page: InputBindingsPage = $InputBindingsPage

func _ready() -> void:
	super._ready()
	InputHelper.device_changed.connect(_on_device_change)
	_look_sensitivity_mouse_slider.slider_value = SaveManager.settings.look_sensitivity_mouse
	_look_sensitivity_joystick_slider.slider_value = SaveManager.settings.look_sensitivity_joystick
	_invert_mouse_x_select.current_option = SaveManager.settings.invert_mouse_x
	_invert_mouse_y_select.current_option = SaveManager.settings.invert_mouse_y
	_invert_joystick_x_select.current_option = SaveManager.settings.invert_joystick_x
	_invert_joystick_y_select.current_option = SaveManager.settings.invert_joystick_y

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

func _on_bindings_button_pressed() -> void:
	_stack(_bindings_page)
