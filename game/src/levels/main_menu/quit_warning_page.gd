class_name QuitWarningPage extends MenuPage

@onready var _yes_button: UIButton = _contents.get_node_or_null("YesButton")

signal quit_confirmed

func _on_visibility_changed() -> void:
	super._on_visibility_changed()
	if visible:
		_yes_button.grab_focus()

func _on_yes_button_pressed() -> void:
	quit_confirmed.emit()

func _on_no_button_pressed() -> void:
	_fade_out()
