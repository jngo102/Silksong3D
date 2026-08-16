extends Node

func find_all_children_of_type(root: Node, type: GDScript) -> Array[Node]:
	var children: Array[Node] = []
	for child in root.get_children():
		if child.get_script() == type:
			children.append(child)
		children.append_array(find_all_children_of_type(child, type))
	return children
