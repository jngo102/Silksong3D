class_name Needle extends Node3D

@export var _recoiler: Recoiler

@onready var _animator: AnimationPlayer = $Animator
@onready var _slash_damager: Damager = $SlashEffect/SlashEffectDamager

signal down_spiked
signal slashed
signal stabbed

var slashing: bool:
	get:
		return _animator.current_animation == &"Slash" and _animator.is_playing()

var down_spike_hit: bool

func slash() -> void:
	if not slashing:
		_animator.play(&"Slash")
		slashed.emit()

func down_spike() -> void:
	_animator.play(&"Down Spike")

func _down_spike_bounce() -> void:
	down_spiked.emit()
	down_spike_hit = true
	_animator.play(&"Down Spike Bounce")

func down_spike_reset() -> void:
	_animator.play(&"RESET")
	down_spike_hit = false

func _on_down_spike_damager_area_entered(area: Area3D) -> void:
	if area is Health:
		_down_spike_bounce()

func _stab_hit() -> void:
	stabbed.emit()

func _on_stab_damager_area_entered(area: Area3D) -> void:
	if area is Health:
		_stab_hit()

func _on_slash_effect_damager_damaged(health: Health) -> void:
	if is_instance_valid(_recoiler):
		_recoiler.recoil(-_slash_damager.global_hit_direction, _slash_damager.hit_force)
