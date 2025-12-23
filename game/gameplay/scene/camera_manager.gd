extends Node

var current_camera: GameCamera:
	get:
		return get_tree().get_first_node_in_group(&"Cameras")

var camera_shaker: Shaker:
	get:
		return current_camera.get_node_or_null("Shaker")

func shake_camera(amount: float = 1, duration: float = 0.5, in_place: bool = true, taper_off: bool = true) -> void:
	current_camera.shake(amount, duration, in_place, taper_off)
