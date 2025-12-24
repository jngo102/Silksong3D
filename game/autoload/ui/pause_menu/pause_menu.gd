class_name PauseMenu extends StackableUI

@onready var _animator: AnimationPlayer = $Animator
@onready var _background_blur: TextureRect = $BackgroundBlur
@onready var _margin_container: MarginContainer = $MarginContainer
@onready var _menu_buttons: VBoxContainer = _margin_container.get_node_or_null("MenuButtons")
@onready var _quit_warning_page: QuitWarningPage = _margin_container.get_node_or_null("QuitWarningPage")
@onready var _settings_ui: SettingsUI = $SettingsUI

func _ready() -> void:
	super._ready()
	var viewport_texture: ViewportTexture = get_viewport().get_texture()
	_background_blur.texture = ImageTexture.create_from_image(viewport_texture.get_image())

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_pause") and not _animator.is_playing():
		_pause(not get_tree().paused)

func _pause(pause: bool = true) -> void:
	if pause and not get_tree().paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		UIManager.get_ui(Fader).hide()
		_animator.play(&"Open")
	elif not pause and get_tree().paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		_animator.play(&"Close")

func _do_pause(pause: bool) -> void:
	get_tree().paused = pause

func _on_resume_button_pressed() -> void:
	_pause(false)

func _on_restart_button_pressed() -> void:
	_pause(false)
	SceneManager.reload()

func _on_options_button_pressed() -> void:
	_stack(_settings_ui)

func _on_settings_ui_hidden() -> void:
	pop()

func _on_quit_button_pressed() -> void:
	_stack(_quit_warning_page)

func _on_quit_warning_page_hidden() -> void:
	pop()

func _on_quit_warning_page_quit_confirmed() -> void:
	_do_pause(false)
	SceneManager.go_to_main_menu()

func _on_uis_emptied() -> void:
	_menu_buttons.get_child(1).grab_focus()
