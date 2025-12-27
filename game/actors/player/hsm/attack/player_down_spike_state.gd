class_name PlayerDownSpikeState extends PlayerAttackState

@export var _down_spike_transition_tree: AnimationTree
@export var _down_spike_antic_animation_name: StringName = &"Down Spike Antic"
@export var _down_spike_speed: float = 120
@export var _needle: Needle
@export var _needle_animator: AnimationPlayer
@export var _down_spike_time: float = 0.25

var _original_gravity_scale: float
var _down_spike_timer: float

func _ready() -> void:
	await super._ready()
	_down_spike_transition_tree.animation_finished.connect(_on_animation_finish)
	_needle.down_spiked.connect(_on_needle_down_spiked)

func _enter() -> void:
	_attack_voice_clips.play_random(_player.global_position)
	_down_spike_timer = 0
	_down_spike_transition_tree.set_active(true)
	_needle_animator.play(&"Down Spike")
	_original_gravity_scale = _player.gravity_scale
	_player.gravity_scale = 0

func _exit() -> void:
	_down_spike_transition_tree.set_active(false)
	_needle.down_spike_reset()
	_player.armature.rotation = Vector3.ZERO
	_player.gravity_scale = _original_gravity_scale

func _update(delta: float) -> void:
	_down_spike_timer += delta
	if _down_spike_timer > _down_spike_time:
		send_event(_hsm.EVENT_FINISHED)
	elif _player.is_on_floor():
		send_event(_hsm.LAND_EVENT)

func _attack() -> void:
	var down_spike_direction: Vector3 = -_player.camera_controller.camera.global_basis.z.normalized()
	_attack_effect_clips.play_random(_player.global_position)
	_player.armature.look_at(_player.global_position + down_spike_direction)
	_player.velocity = down_spike_direction * _down_spike_speed

func _on_animation_finish(anim_name: StringName) -> void:
	match anim_name:
		_down_spike_antic_animation_name:
			_attack()

func _on_needle_down_spiked() -> void:
	send_event(_hsm.HIT_EVENT)
