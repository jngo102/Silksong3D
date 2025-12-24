class_name PlayerSprintStabState extends PlayerAttackState

@export var _sprint_stab_animation_name: StringName = &"Sprint Stab"
@export var _needle: Needle
@export var _needle_stab_animation_name: StringName = &"Stab"
@export var _stab_speed: float = 48
@export var _stab_time: float = 0.4

@onready var _needle_animator: AnimationPlayer = _needle.get_node_or_null("Animator")

var _dash_audio: AudioStream = preload("uid://dypt7aefw1r23")

var _stab_timer: float

func _ready() -> void:
	await super._ready()
	_needle.stabbed.connect(_on_needle_stab)

func _enter() -> void:
	_stab_timer = 0
	_player.move(Vector2.UP * _stab_speed)
	AudioManager.play_clip(_dash_audio, false, _player.global_position, 0.85, 1.15)
	play_anim(_sprint_stab_animation_name)
	super._enter()

func _exit() -> void:
	_needle_animator.play(&"RESET", -1, 0.25)

func _update(delta: float) -> void:
	_stab_timer += delta
	if _stab_timer > _stab_time:
		send_event(_hsm.EVENT_FINISHED)

func _attack() -> void:
	super._attack()
	_needle_animator.play(_needle_stab_animation_name)

func _on_needle_stab() -> void:
	send_event(_hsm.HIT_EVENT)
