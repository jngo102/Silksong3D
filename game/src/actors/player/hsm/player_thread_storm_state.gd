class_name PlayerThreadStormState extends PlayerAttackState

@export var _min_attack_time: float = 1
@export var _max_attack_time: float = 2
@export var _extend_spam_time: float = 0.25
@export var _thread_storm_prepare_animation_name: StringName = &"Thread Storm Prepare"
@export var _thread_storm_transition_tree: AnimationTree
@export var _thread_storm_animation_name: StringName = &"Thread Storm"
@export var _thread_storm_prefab: PackedScene

var _attack_timer: float
var _original_gravity_scale: float
var _spam_timer: float
var _thread_storm: Node3D

func _ready() -> void:
	await super._ready()
	_thread_storm_transition_tree.animation_finished.connect(_on_thread_storm_animation_finish)

func _enter() -> void:
	_attack_voice_clips.play_random(_player.global_position)
	_thread_storm_transition_tree.set_active(true)
	_attack_timer = 0
	_original_gravity_scale = _player.gravity_scale
	_player.gravity_scale = 0
	_player.spool_manager.current_silk -= _player.spool_manager.skill_silk
	_player.velocity = Vector3.ZERO
	_spam_timer = 0

func _exit() -> void:
	_player.gravity_scale = _original_gravity_scale
	if is_instance_valid(_thread_storm):
		_thread_storm.queue_free()
	_thread_storm_transition_tree.set_active(false)

func _update(delta: float) -> void:
	_attack_timer += delta
	_spam_timer += delta
	if _attack_timer > _max_attack_time or (_attack_timer > _min_attack_time and _spam_timer > _extend_spam_time):
		send_event(_hsm.EVENT_FINISHED)
	elif _attack_timer > _min_attack_time:
		var damager: Damager = _thread_storm.get_node_or_null("Damager")
		if is_instance_valid(damager):
			damager.damage_amount = 2
	if Input.is_action_pressed(&"Skill"):
		_spam_timer = 0

func _attack() -> void:
	_thread_storm = _thread_storm_prefab.instantiate()
	_player.add_child(_thread_storm)

func can_enter() -> bool:
	return _player.spool_manager.current_silk >= _player.spool_manager.skill_silk

func _on_thread_storm_animation_finish(anim_name: StringName) -> void:
	match anim_name:
		_thread_storm_prepare_animation_name:
			_attack()
