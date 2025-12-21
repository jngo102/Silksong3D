class_name PlayerAttackState extends PlayerState

@export var _attack_voice_clips: RandomAudioPlay
@export var _attack_effect_clips: RandomAudioPlay

func _enter() -> void:
	_attack()

func _attack() -> void:
	_attack_voice_clips.play_random(_player.global_position)
	_attack_effect_clips.play_random(_player.global_position)
