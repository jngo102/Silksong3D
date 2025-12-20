class_name PlayerLandState extends PlayerState

@export var _land_animation_name: StringName

func _enter() -> void:
	play_anim(_land_animation_name)

func _update(_delta: float) -> void:
	var move_vector: Vector2 = Input.get_vector(&"ui_left", &"ui_right", &"ui_up", &"ui_down")
	if move_vector.length() > 0:
		if Input.is_action_pressed(&"Dash"):
			send_event(_hsm.DASH_EVENT)
		else:
			send_event(_hsm.MOVE_EVENT)
	else:
		send_event(_hsm.STOP_EVENT)
