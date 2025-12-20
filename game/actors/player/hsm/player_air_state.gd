class_name PlayerAirState extends PlayerState

var _gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var _mid_air_move_speed: float = 24

func _update(delta: float) -> void:
	if _player.is_on_floor():
		send_event(_hsm.LAND_EVENT)
	elif Input.is_action_just_pressed(&"Dash"):
		send_event(_hsm.DASH_EVENT)
