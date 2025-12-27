class_name GraphicsSettingsPage extends SettingsPage

@onready var _resolution_select_option: SettingSelectOption = $ResolutionSelectOption
@onready var _display_mode_select_option: SettingSelectOption = $DisplayModeSelectOption
@onready var _v_sync_select_option: SettingSelectOption = $VSyncSelectOption

var _pending_resolution: Vector2i
var _pending_window_mode: DisplayServer.WindowMode
var _pending_vsync_enabled: bool

func _ready() -> void:
	_resolution_select_option.current_option = SaveManager.settings.display_resolution
	_display_mode_select_option.current_option = SaveManager.settings.display_mode
	_v_sync_select_option.current_option = SaveManager.settings.v_sync_enabled

func _on_resolution_select_option_value_changed(resolution: Vector2i) -> void:
	_pending_resolution = resolution

func _on_display_mode_select_option_value_changed(window_mode: int) -> void:
	_pending_window_mode = window_mode

func _on_v_sync_select_option_value_changed(vsync_enabled: bool) -> void:
	_pending_vsync_enabled = vsync_enabled

func _on_apply_button_pressed() -> void:
	SaveManager.settings.display_resolution = _pending_resolution
	SaveManager.settings.display_mode = _pending_window_mode
	SaveManager.settings.v_sync_enabled = _pending_vsync_enabled
	
	DisplayServer.window_set_size(_pending_resolution)
	DisplayServer.window_set_mode(_pending_window_mode)
	if _pending_vsync_enabled:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
