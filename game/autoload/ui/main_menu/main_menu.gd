## The game's main menu
class_name MainMenu extends Control

## Parent container of menu buttons list
@onready var _margin_container: MarginContainer = $MarginContainer
## List of all main menu buttons
@onready var _menu_buttons: WrappingUIList = _margin_container.get_node_or_null("Contents/CenterContainer/MenuButtons")
## The button to quit the game
@onready var _quit_button: UIButton = _menu_buttons.get_node_or_null("QuitGameButton")
## Warning for whether the player really wants to exit the game
#@onready var _quit_warning: Panel = $quit_warning
@onready var _settings_ui: SettingsUI = _margin_container.get_node_or_null("SettingsUI")
@onready var _profiles_page: BossFightProfilesPage = _margin_container.get_node_or_null("BossFightProfilesPage")

var _title_music: MusicTrack = preload("uid://cq5xyomalenfy")

func _ready() -> void:
	AudioManager.play_music(_title_music, 0, 1)
	_menu_buttons.grab_focus()
	if OS.get_name() == "Web":
		_quit_button.hide()

func _on_select_fight_button_pressed() -> void:
	_menu_buttons.hide()
	_profiles_page.show()

func _on_options_button_pressed() -> void:
	_menu_buttons.hide()
	_settings_ui.show()

func _on_credits_button_pressed() -> void:
	pass # Replace with function body.

func _on_quit_button_pressed() -> void:
	_menu_buttons.hide()
	#_quit_warning.show()
#
func _on_quit_warning_quit_canceled() -> void:
	#_quit_warning.hide()
	_menu_buttons.show()

func _on_quit_warning_quit_confirmed() -> void:
	get_tree().quit()

func _on_settings_ui_hidden() -> void:
	_menu_buttons.show()
	_menu_buttons.grab_focus()

func _on_boss_fight_profiles_page_hidden() -> void:
	_menu_buttons.show()
	_menu_buttons.grab_focus()
