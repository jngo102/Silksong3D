class_name Pulser extends Node

@export var _pulse_rate: float = 0.25
@export var _flasher: Flasher

var _pulse_on: bool

func start_pulse() -> void:
	_pulse_on = false
	if not _flasher.flash_finished.is_connected(_on_flash_finish):
		_flasher.flash_finished.connect(_on_flash_finish)
		_flasher.flash(0, 1, _pulse_rate)

func stop_pulse() -> void:
	if _flasher.flash_finished.is_connected(_on_flash_finish):
		_flasher.flash_finished.disconnect(_on_flash_finish)
	_flasher.reset()

func _on_flash_finish() -> void:
	_pulse_on = not _pulse_on
	if _pulse_on:
		_flasher.flash(1, 0, _pulse_rate)
	else:
		_flasher.flash(0, 1, _pulse_rate)
