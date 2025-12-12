class_name CorpsePiece extends RigidBody3D

@export var explode_speed: float

func _ready() -> void:
	var explode_vector := Vector3(randf_range(-1, 1), randf_range(1, 4), randf_range(-1, 1)).normalized()
	apply_impulse(explode_vector * explode_speed, $ExplodePoint.global_position)
