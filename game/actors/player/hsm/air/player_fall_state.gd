class_name PlayerFallState extends PlayerAirState

@export var _fall_animation_name: StringName

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"Attack"):
		send_event(_hsm.ATTACK_EVENT)

func _enter() -> void:
	play_anim(_fall_animation_name, 0.5)

func _update(delta: float) -> void:
	super._update(delta)
	_player.turn_to_camera(delta)
	if Input.is_action_just_pressed(&"Jump"):
		send_event(_hsm.JUMP_EVENT)
