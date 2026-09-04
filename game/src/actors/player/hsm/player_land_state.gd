class_name PlayerLandState extends PlayerState

@export var _land_animation_name: StringName

func _enter() -> void:
	play_anim(_land_animation_name)

func _update(delta: float) -> void:
	super._update(delta)
	var move_vector: Vector2 = Input.get_vector(&"Left", &"Right", &"Forward", &"Backward")
	if move_vector.length() > 0:
		if Input.is_action_pressed(&"Dash"):
			send_event(_hsm.DASH_EVENT)
		else:
			send_event(_hsm.MOVE_EVENT)
	else:
		send_event(_hsm.STOP_EVENT)
