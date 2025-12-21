class_name PlayerState extends LimboState

@onready var _player: Player = owner
@onready var _hsm: PlayerHSM = get_parent()

var _model_animator: AnimationPlayer

func _ready() -> void:
	await _player.ready
	_model_animator = _player.model_animator
	_player.health.took_damage.connect(_on_take_damage)

func _update(delta: float) -> void:
	if Input.is_action_just_pressed(&"Bind"):
		send_event(_hsm.BIND_EVENT)

func send_event(event: StringName, state: LimboState = get_root()) -> void:
	state.dispatch(event)

func play_anim(anim_name: StringName, blend: float = 0.125) -> void:
	if _model_animator.current_animation != anim_name:
		_model_animator.play(anim_name, blend)

func _on_take_damage(damager: Damager) -> void:
	if damager.damage_amount > 1:
		send_event(_hsm.BIG_DAMAGE_EVENT)
	elif damager.damage_amount == 1:
		send_event(_hsm.DAMAGE_EVENT)
