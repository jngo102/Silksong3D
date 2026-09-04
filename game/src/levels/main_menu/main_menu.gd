## The game's main menu
class_name MainMenu extends StackableUI

## Parent container of menu buttons list
@onready var _margin_container: MarginContainer = $Margins
@onready var _settings_ui: SettingsUI = $SettingsUI
@onready var _profiles_page: BossFightProfilesPage = $BossFightProfilesPage
@onready var _quit_warning: QuitWarningPage = $QuitWarningPage

var _title_music: MusicTrack = preload("uid://cq5xyomalenfy")

func _ready() -> void:
	super._ready()
	AudioManager.play_music(_title_music)
	Input.mouse_mode = Input.MouseMode.MOUSE_MODE_VISIBLE

# Avoid main menu from being hidden
func _unhandled_input(_event: InputEvent) -> void:
	pass

func _on_select_fight_button_pressed() -> void:
	_show_child(_profiles_page)

func _on_options_button_pressed() -> void:
	_show_child(_settings_ui)

func _on_quit_game_button_pressed() -> void:
	_show_child(_quit_warning)

func _on_quit_warning_page_quit_confirmed() -> void:
	var fader: Fader = UIManager.open_ui(Fader)
	await fader.faded_in
	get_tree().quit()
