class_name RecoilManager extends Node3D
@export var _anim_tree: AnimationTree
@export var _health: Health
@export var _hit_pause_duration: float = 0.5
@export var _normal_hurt_voice_clips: RandomAudioPlay
@export var _big_hurt_voice_clips: RandomAudioPlay
@export var _normal_damage_effect_prefab: PackedScene
@export var _big_damage_effect_prefab: PackedScene

func _ready() -> void:
	_health.took_damage.connect(_on_take_damage)

func _on_take_damage(damager: Damager) -> void:
	var state_machine: AnimationNodeStateMachinePlayback = _anim_tree.get("parameters/playback")
	state_machine.start(&"Recoil", true)
	owner.look_at(damager.global_position)
	owner.rotation.x = 0
	owner.rotation.z = 0
	if damager.damage_amount == 1 and is_instance_valid(_normal_damage_effect_prefab):
		var normal_damage_effect = _normal_damage_effect_prefab.instantiate()
		normal_damage_effect.global_position = global_position
		get_tree().root.add_child(normal_damage_effect)
		_normal_hurt_voice_clips.play_random(global_position)
	elif damager.damage_amount > 1 and is_instance_valid(_big_damage_effect_prefab):
		print("BIG DAMAGE")
		var big_damage_effect = _big_damage_effect_prefab.instantiate()
		get_tree().root.add_child(big_damage_effect)
		big_damage_effect.global_position = global_position
		_big_hurt_voice_clips.play_random(global_position)
	TimeManager.stop_time(true, _hit_pause_duration)
