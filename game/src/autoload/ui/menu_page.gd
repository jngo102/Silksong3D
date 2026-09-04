## Panel for modifying a specific category of options
class_name MenuPage extends StackableUI

@onready var _animator: AnimationPlayer = $Animator
## The parent container of the content in this panel
@onready var _page: WrappingUIList = $Margins/Page
@onready var _contents: VBoxContainer = _page.get_node("Contents")
## Button to go back
@onready var _back_button: UIButton = _page.get_node("BackButton")

func _on_back_button_pressed() -> void:
	hide_self(false)

func _on_contents_visibility_changed() -> void:
	if is_instance_valid(_page) and _page.is_visible_in_tree():
		_animator.play(&"Show")
		_page.update_focus.call_deferred()
		await get_tree().process_frame
		reset_focus()
		_reset(true)
