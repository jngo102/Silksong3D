class_name PlayerIdleState extends PlayerGroundState

@export var _idle_animation_name: StringName

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"Attack"):
		send_event(_hsm.ATTACK_EVENT)
	elif event.is_action_pressed(&"Skill"):
		send_event(_hsm.SKILL_EVENT)

func _enter() -> void:
	play_anim(_idle_animation_name)
	_player.velocity = Vector3(0, _player.velocity.y, 0)

func _update(delta: float) -> void:
	_player.turn_to_camera(delta)
	super._update(delta)
	var move_vector: Vector2 = Input.get_vector(&"ui_left", &"ui_right", &"ui_up", &"ui_down")
	if move_vector.length() > 0:
		send_event(_hsm.MOVE_EVENT)
	elif Input.is_action_just_pressed(&"Dash"):
		send_event(_hsm.DASH_EVENT)
