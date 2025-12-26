class_name GraphicsSettingsPage extends SettingsPage

@onready var _resolution_select_option: SettingSelectOption = $ResolutionSelectOption
@onready var _display_mode_select_option: SettingSelectOption = $DisplayModeSelectOption
@onready var _v_sync_select_option: SettingSelectOption = $VSyncSelectOption

var _pending_resolution: Vector2i
var _pending_window_mode: Window.Mode
var _pending_vsync_mode: DisplayServer.VSyncMode

func _ready() -> void:
	_resolution_select_option.current_option = SaveManager.settings.display_resolution
	_display_mode_select_option.current_option = ProjectSettings.get_setting("display/window/size/mode")
	_v_sync_select_option.current_option = (ProjectSettings.get_setting("display/window/vsync/vsync_mode") == DisplayServer.VSYNC_ENABLED)

func _on_resolution_select_option_value_changed(resolution: Vector2i) -> void:
	_pending_resolution = resolution

func _on_display_mode_select_option_value_changed(window_mode: Window.Mode) -> void:
	_pending_window_mode = window_mode

func _on_v_sync_select_option_value_changed(vsync_on: bool) -> void:
	_pending_vsync_mode = DisplayServer.VSYNC_ENABLED if vsync_on else DisplayServer.VSYNC_DISABLED

func _on_apply_button_pressed() -> void:
	SaveManager.settings.display_resolution = _pending_resolution
	ProjectSettings.set_setting("display/window/size/mode", _pending_window_mode)
	ProjectSettings.set_setting("display/window/vsync/vsync_mode", _pending_vsync_mode)
	get_tree().root.size = _pending_resolution
