class_name PlayerDownSpikeBounceState extends PlayerAirState

@export var _down_spike_bounce_animation_prefix: StringName = &"Down Spike Bounce "
@export var _spin_speeds: Dictionary[int, float]
@export var _down_spike_bounce_speed: float = 120
@export var _needle_animator: AnimationPlayer
@export var _down_spike_bounce_time: float = 0.5

var _animation_index: int
var _down_spike_bounce_timer: float

var _spin_speed: float:
	get:
		return _spin_speeds[_animation_index]

func _enter() -> void:
	_animation_index = _spin_speeds.keys()[randi() % len(_spin_speeds)]
	var down_spike_bounce_animation_name: StringName = _down_spike_bounce_animation_prefix + str(_animation_index)
	play_anim(down_spike_bounce_animation_name)
	_needle_animator.play(&"Down Spike Bounce")
	_player.health.set_invincible(true, 0.2)
	_player.velocity.y = _down_spike_bounce_speed
	_down_spike_bounce_timer = 0

func _exit() -> void:
	_player.armature.rotation.x = 0

func _update(delta: float) -> void:
	_down_spike_bounce_timer += delta
	if _down_spike_bounce_timer > _down_spike_bounce_time:
		send_event(_hsm.EVENT_FINISHED)
	super._update(delta)
	_player.armature.rotation_degrees.x += _spin_speed * delta
	_player.turn_to_camera(delta)
	var move_vector: Vector2 = Input.get_vector(&"Left", &"Right", &"Forward", &"Backward")
	_player.move(move_vector.normalized() * _mid_air_move_speed)
	if Input.is_action_just_pressed(&"Jump"):
		send_event(_hsm.JUMP_EVENT)
