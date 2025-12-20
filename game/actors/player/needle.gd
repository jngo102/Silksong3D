class_name Needle extends Node3D

@onready var _animator: AnimationPlayer = $Animator

signal slashed
signal down_spiked

var slashing: bool:
	get:
		return _animator.current_animation == "Slash" and _animator.is_playing()

var down_spike_hit: bool

func slash() -> void:
	if not slashing:
		_animator.play("Slash")
		slashed.emit()

func down_spike() -> void:
	_animator.play("Down Spike")

func _down_spike_bounce() -> void:
	down_spiked.emit()
	down_spike_hit = true
	_animator.play("Down Spike Bounce")

func down_spike_reset() -> void:
	_animator.play("RESET")
	down_spike_hit = false

func _on_down_spike_damager_area_entered(area: Area3D) -> void:
	if area is Health:
		_down_spike_bounce()
