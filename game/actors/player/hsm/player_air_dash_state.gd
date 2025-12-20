class_name PlayerAirDashState extends PlayerAirState

@export var _air_dash_animation_name: StringName = &"Air Dash"
@export var _dash_speed: float = 48
@export var _spin_speed: float = 720
@export var _air_dash_time: float = 1.0 / 3

var _air_dash_timer: float

func _enter() -> void:
	play_anim(_air_dash_animation_name)
	var input_vector: Vector2 = Input.get_vector(&"ui_left", &"ui_right", &"ui_up", &"ui_down")
	_player.face_direction(Vector3(input_vector.x, 0, input_vector.y))
	_player.velocity.y = 0
	_player.move(Vector2.UP * _dash_speed)
	_air_dash_timer = 0

func _exit() -> void:
	_player.armature.rotation.x = 0

func _update(delta: float) -> void:
	if _player.is_on_floor():
		send_event(_hsm.MOVE_EVENT)
		return
	_air_dash_timer += delta
	_player.armature.rotation_degrees.x += _spin_speed * delta
	if _air_dash_timer > _air_dash_time:
		send_event(_hsm.EVENT_FINISHED)
