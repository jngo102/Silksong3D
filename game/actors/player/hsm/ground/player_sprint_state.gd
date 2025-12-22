class_name PlayerSprintState extends PlayerGroundState

@export var _sprint_animation_name: StringName = &"Sprint"
@export var _sprint_speed: float = 48

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"Attack"):
		send_event(_hsm.ATTACK_EVENT)
	elif event.is_action_pressed(&"Skill"):
		send_event(_hsm.SKILL_EVENT)

func _enter() -> void:
	play_anim(_sprint_animation_name, 0.125)

func _update(delta: float) -> void:
	super._update(delta)
	if not Input.is_action_pressed(&"Dash"):
		send_event(_hsm.STOP_EVENT)
	else:
		var move_vector: Vector2 = Input.get_vector(&"ui_left", &"ui_right", &"ui_up", &"ui_down")
		if move_vector.length() > 0:
			_player.face_direction(Vector3(move_vector.x, 0, move_vector.y))
			_player.move(Vector2.UP * _sprint_speed)
		else:
			send_event(_hsm.STOP_EVENT)
