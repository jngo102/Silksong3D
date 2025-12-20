class_name PlayerSlashState extends PlayerState

@export var _slash_animation_name: StringName = &"Slash"
@export var _needle_animator: AnimationPlayer
@export var _slash_needle_animation_name: StringName = &"Slash"
@export var _attack_voice_clips: RandomAudioPlay

func _enter() -> void:
	play_anim(_slash_animation_name)
	_attack_voice_clips.play_random(_player.global_position)
	_needle_animator.play(_slash_needle_animation_name)

func _update(_delta: float) -> void:
	if _model_animator.current_animation != _slash_animation_name:
		send_event(_hsm.EVENT_FINISHED)
