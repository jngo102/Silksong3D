class_name PlayerSlashState extends PlayerAttackState

@export var _slash_animation_name: StringName = &"Slash"
@export var _needle_animator: AnimationPlayer
@export var _slash_needle_animation_name: StringName = &"Slash"
@export var _walk_speed: float = 24

func _update(delta: float) -> void:
	_player.turn_to_camera(delta)
	if _model_animator.current_animation != _slash_animation_name:
		send_event(_hsm.EVENT_FINISHED)
	else:
		var move_vector: Vector2 = Input.get_vector(&"ui_left", &"ui_right", &"ui_up", &"ui_down")
		_player.move(move_vector * _walk_speed)

func _attack() -> void:
	super._attack()
	play_anim(_slash_animation_name)
	_needle_animator.play(_slash_needle_animation_name)
	_player.move(Vector2.ZERO)
