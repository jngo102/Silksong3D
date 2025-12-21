class_name SpoolChunk extends Control

var chunk_index: int
var animation_index: int
var up: bool
var glow: bool

var spool_manager: SpoolManager

func _ready() -> void:
	animation_index = randi_range(1, 3)
	spool_manager.silk_changed.connect(_on_silk_change)
	spool_manager.bind_state_changed.connect(_on_bind_state_change)

func _up() -> void:
	up = true

func _down() -> void:
	up = false

func _on_silk_change(new_value: int) -> void:
	if new_value >= chunk_index:
		_up()
	else:
		_down()

func _on_bind_state_change(can_bind: bool) -> void:
	if spool_manager.bind_silk >= chunk_index:
		glow = can_bind
