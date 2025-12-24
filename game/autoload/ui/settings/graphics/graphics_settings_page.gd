class_name GraphicsSettingsPage extends SettingsPage

@onready var _resolution_select_option: SettingSelectOption = $ResolutionSelectOption

var _pending_resolution: Vector2i

func _ready() -> void:
	_resolution_select_option.current_option = SaveManager.settings.display_resolution

func _on_resolution_select_option_value_changed(new_value: Vector2i) -> void:
	_pending_resolution = new_value

func _on_apply_button_pressed() -> void:
	SaveManager.settings.display_resolution = _pending_resolution
	get_tree().root.size = _pending_resolution
	#SceneManager.screen.size = _pending_resolution
