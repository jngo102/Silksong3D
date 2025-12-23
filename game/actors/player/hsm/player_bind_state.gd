class_name PlayerBindState extends PlayerState

@export var _bind_effect: Node3D
@export var _bind_animator: AnimationPlayer
@export var _bind_spin_speed: float = 360
@export var _bind_time: float = 2
@export var _bind_voice_clips: RandomAudioPlay
@export var _needle_animator: AnimationPlayer

var _bind_timer: float
var _original_gravity_scale: float
var _bind_tween: Tween
var _bind_sfx: AudioStream = preload("uid://ckcybm5veeh7y")

func _enter() -> void:
	if _player.is_on_floor():
		play_anim(&"Bind Ground")
	else:
		play_anim(&"Bind Air")
	_needle_animator.play(&"Bind", 0.25)
	_player.velocity = Vector3.ZERO
	_bind_effect.scale = Vector3.ONE
	_bind_effect.show()
	_bind_voice_clips.play_random(_player.global_position)
	_bind_timer = 0
	_original_gravity_scale = _player.gravity_scale
	_player.gravity_scale = 0

func _exit() -> void:
	_bind_effect.hide()
	_needle_animator.play(&"RESET", 0.25)
	_player.gravity_scale = _original_gravity_scale
	_player.spool_manager.current_silk -= _player.spool_manager.bind_silk
	if is_instance_valid(_bind_tween) and _bind_tween.is_running():
		_bind_tween.kill()
	_bind_tween = null

func _update(delta: float) -> void:
	_bind_effect.rotation_degrees.y += _bind_spin_speed * delta
	_bind_timer += delta
	if _bind_timer > _bind_time and not is_instance_valid(_bind_tween):
		_start_bind()

func _start_bind() -> void:
	AudioManager.play_clip(_bind_sfx, true)
	_bind_tween = create_tween()
	_bind_tween.tween_property(_bind_effect, "scale", Vector3(0.01, 1, 0.01), 0.25).from_current()
	_bind_tween.tween_callback(func():
		_bind_effect.hide()
		_bind_heal())

func _bind_heal() -> void:
	_player.health.heal(3)
	_bind_animator.play(&"Bind")
	send_event(_hsm.EVENT_FINISHED)

func can_enter() -> bool:
	return _player.spool_manager.current_silk >= _player.spool_manager.bind_silk
