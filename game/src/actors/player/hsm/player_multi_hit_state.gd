class_name PlayerMultiHitState extends PlayerRecoilState

@export var _multi_hit_prefab: PackedScene = preload("uid://cfdqqmn0gbo8p")

var _multi_hit_effect: Node3D
var _original_gravity_scale: float

func _ready() -> void:
	await super._ready()
	_player.health.multi_hit_ended.connect(_on_multi_hit_end)

func _enter() -> void:
	play_anim(_recoil_animation_name)
	_hurt_voice_clips.play_random(_player.global_position)
	_multi_hit_effect = _multi_hit_prefab.instantiate()
	_player.add_child(_multi_hit_effect)
	if _hsm.get_previous_active_state() == _hsm.bind_state:
		var bind_break_effect: Node3D = _bind_break_effect_prefab.instantiate()
		_player.add_child(bind_break_effect)
	_original_gravity_scale = _player.gravity_scale
	_player.gravity_scale = 0
	_player.velocity = Vector3.ZERO

func _exit() -> void:
	var damage_effect: Node3D = _damage_effect_prefab.instantiate()
	_player.add_child.call_deferred(damage_effect)
	_multi_hit_effect.queue_free()
	_player.gravity_scale = _original_gravity_scale
	TimeManager.stop_time(true, _hit_pause_duration)

func _on_multi_hit_end() -> void:
	send_event(_hsm.EVENT_FINISHED)
