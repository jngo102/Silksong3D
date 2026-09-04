class_name Spinner extends Node3D

@export var deg_per_sec: float = 90

var _spinning: bool

func _process(delta: float) -> void:
	if _spinning:
		rotation_degrees.y += deg_per_sec * delta

func start_spinning() -> void:
	_spinning = true

func stop_spinning() -> void:
	_spinning = false
