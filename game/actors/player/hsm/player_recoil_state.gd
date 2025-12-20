class_name PlayerRecoilState extends PlayerState

@export var _recoil_animation_name: StringName = &"Recoil"
@export var _hit_pause_duration: float = 0.125
@export var _hurt_voice_clips: RandomAudioPlay
@export var _damage_effect_prefab: PackedScene

func _enter() -> void:
	play_anim(_recoil_animation_name)
	_hurt_voice_clips.play_random(_player.global_position)
	var damage_effect: Node3D = _damage_effect_prefab.instantiate()
	_player.add_child(damage_effect)
	TimeManager.stop_time(true, _hit_pause_duration)

func _update(_delta: float) -> void:
	if _model_animator.current_animation != _recoil_animation_name:
		send_event(_hsm.EVENT_FINISHED)
