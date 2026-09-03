## List whose contents wrap around
class_name WrappingUIList extends BoxContainer

func _ready() -> void:
	update_focus()

func update_focus() -> void:
	var focusables: Array[Node] = find_children("*", "Control", true, false).filter(func(child):
		return child is Control and child.is_visible_in_tree() and child.focus_mode == FocusMode.FOCUS_ALL)
	var num_focusables: int = len(focusables)
	if num_focusables > 0:
		for i in num_focusables:
			var prev: Control = focusables[wrapi(i - 1, 0, num_focusables)]
			var current: Control = focusables[i]
			var next: Control = focusables[wrapi(i + 1, 0, num_focusables)]
			if vertical:
				if is_instance_valid(prev):
					current.focus_neighbor_top = prev.get_path()
				if is_instance_valid(next):
					current.focus_neighbor_bottom = next.get_path()
			else:
				if is_instance_valid(prev):
					current.focus_neighbor_left = prev.get_path()
				if is_instance_valid(next):
					current.focus_neighbor_right = next.get_path()
