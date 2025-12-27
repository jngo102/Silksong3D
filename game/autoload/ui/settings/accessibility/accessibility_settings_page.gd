class_name AccessibilitySettingsPage extends VBoxContainer

@onready var _screen_shake_slider: SettingValueSlider = $ScreenShakeSlider

func _ready() -> void:
	_screen_shake_slider.slider_value = SaveManager.settings.screen_shake_intensity

func _on_screen_shake_slider_value_changed(new_value: float) -> void:
	SaveManager.settings.screen_shake_intensity = new_value
