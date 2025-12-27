class_name SettingsPage extends VBoxContainer
## A page for modifying a specific category of settings

## Focus on a child Control at a specified index
func focus(child_index: int) -> void:
	get_child(child_index).grab_focus()
