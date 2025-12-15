class_name MenuPage extends Control

@onready var _animator: AnimationPlayer = $Animator
@onready var _contents: VBoxContainer = $MarginContainer/Page/Contents

func _on_visibility_changed() -> void:
	if visible:
		_animator.play(&"Show")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_back"):
		_fade_out()

func _on_back_button_pressed() -> void:
	_fade_out()

func _fade_out() -> void:
	_animator.play(&"Show", 0, -1, true)
	var fade_tween: Tween = create_tween()
	fade_tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.25).from(Color.WHITE)
	fade_tween.tween_callback(hide)
