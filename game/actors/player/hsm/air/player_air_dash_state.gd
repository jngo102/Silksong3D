class_name PlayerAirDashState extends PlayerAirState

@export var _air_dash_animation_name: StringName = &"Air Dash"
@export var _dash_speed: float = 48
@export var _spin_speed: float = 720
@export var _air_dash_time: float = 1.0 / 3

var _air_dash_timer: float

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"Attack"):
		send_event(_hsm.ATTACK_EVENT)
	elif event.is_action_pressed(&"Skill"):
		send_event(_hsm.SKILL_EVENT)

var _can_air_dash: bool

func _enter() -> void:
	_can_air_dash = false
	play_anim(_air_dash_animation_name)
	var input_vector: Vector2 = Input.get_vector(&"ui_left", &"ui_right", &"ui_up", &"ui_down")
	_player.face_direction(Vector3(input_vector.x, 0, input_vector.y))
	_player.velocity.y = 0
	_player.move(Vector2.UP * _dash_speed)
	_air_dash_timer = 0

func _exit() -> void:
	_player.armature.rotation.x = 0

func _update(delta: float) -> void:
	_air_dash_timer += delta
	_player.armature.rotation_degrees.x += _spin_speed * delta
	if _air_dash_timer > _air_dash_time:
		send_event(_hsm.EVENT_FINISHED)

func can_enter() -> bool:
	return _can_air_dash

func reset_state() -> void:
	_can_air_dash = true
