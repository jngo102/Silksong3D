class_name SettingValueSlider extends HBoxContainer
## Slider UI component to adjust a setting's range of values

@export var setting_name: String
@export var min_slider_value: float = 0
@export var max_slider_value: float = 1

@onready var _setting_title: Label = $SettingTitle
@onready var _value_slider: HSlider = $ValueSlider
@onready var _value_label: Label = $ValueLabel

var slider_value: float:
	get:
		return _value_slider.value
	set(value):
		_value_slider.value = value
		_value_label.text = str(int(value * 100)) + "%"

## Emitted when the value of the settings slider component changes
signal value_changed(new_value: float)

func _ready() -> void:
	_setting_title.text = setting_name
	_value_slider.min_value = min_slider_value
	_value_slider.max_value = max_slider_value

func _on_value_slider_value_changed(value: float) -> void:
	_value_label.text = str(int(value * 100)) + "%"
	value_changed.emit(value)

func _on_value_editor_value_changed(value: float) -> void:
	var normalized_value: float = value / 100
	_value_slider.value = normalized_value
	value_changed.emit(normalized_value)

func _on_focus_entered() -> void:
	_value_slider.grab_focus()
