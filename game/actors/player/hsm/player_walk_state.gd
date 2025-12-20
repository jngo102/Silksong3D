class_name PlayerWalkState extends PlayerGroundState

const PARAMS: String = "parameters"
const WALK_BLEND: String = "%s/blend_position" % PARAMS

@export var _walk_blend_tree: AnimationTree
@export var _walk_speed: float = 24

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"Attack"):
		send_event(_hsm.ATTACK_EVENT)

func _enter() -> void:
	_walk_blend_tree.set_active(true)

func _exit() -> void:
	_walk_blend_tree.set(WALK_BLEND, Vector2.ZERO)
	_walk_blend_tree.set_active(false)

func _update(delta: float) -> void:
	_player.turn_to_camera(delta)
	super._update(delta)
	var move_vector: Vector2 = Input.get_vector(&"ui_left", &"ui_right", &"ui_up", &"ui_down")
	if move_vector.length() > 0:
		if Input.is_action_just_pressed(&"Dash"):
			send_event(_hsm.DASH_EVENT)
		else:
			_player.move(move_vector * _walk_speed)
			var current_move_blend: Vector2 = _walk_blend_tree.get(WALK_BLEND)
			_walk_blend_tree.set(WALK_BLEND, current_move_blend.move_toward(move_vector.normalized(), delta * 8))
	else:
		send_event(_hsm.STOP_EVENT)
