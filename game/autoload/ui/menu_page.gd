class_name MenuPage extends StackableUI

@onready var _animator: AnimationPlayer = $Animator
@onready var _margin_container: MarginContainer = $MarginContainer
@onready var _page: VBoxContainer = _margin_container.get_node_or_null("Page")
@onready var _contents: VBoxContainer = _page.get_node_or_null("Contents")
@onready var _back_button: UIButton = _page.get_node_or_null("BackButton")

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
