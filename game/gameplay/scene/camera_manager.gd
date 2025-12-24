extends Node

var current_camera: GameCamera:
	get:
		return get_tree().get_first_node_in_group(&"Cameras")

func shake_camera(amount: float = 1, duration: float = 0.5, taper_off: bool = true) -> void:
	current_camera.shake(amount, duration, taper_off)
