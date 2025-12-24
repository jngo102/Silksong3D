class_name QuitWarningPage extends MenuPage

signal quit_confirmed

func _on_yes_button_pressed() -> void:
	quit_confirmed.emit()

func _on_no_button_pressed() -> void:
	_fade_out()
