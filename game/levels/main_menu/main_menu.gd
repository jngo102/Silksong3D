## The game's main menu
class_name MainMenu extends StackableUI

@export var _logo: Node3D

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
@onready var _quit_warning: QuitWarningPage = _margin_container.get_node_or_null("QuitWarningPage")

var _title_music: MusicTrack = preload("uid://cq5xyomalenfy")

func _ready() -> void:
	super._ready()
	AudioManager.play_music(_title_music, 0, 2)
	Input.mouse_mode = Input.MouseMode.MOUSE_MODE_VISIBLE
	_menu_buttons.grab_focus()
	if OS.get_name() == "Web":
		_quit_button.hide()

func _on_select_fight_button_pressed() -> void:
	_stack(_profiles_page)

func _on_options_button_pressed() -> void:
	_stack(_settings_ui)

func _on_quit_game_button_pressed() -> void:
	_stack(_quit_warning)

func _on_quit_warning_page_quit_confirmed() -> void:
	get_tree().quit()

func _on_uis_emptied() -> void:
	_menu_buttons.grab_focus()
