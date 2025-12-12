class_name Death extends Node

@export var corpse_prefab: PackedScene

func die() -> void:
	var corpse: Node3D = corpse_prefab.instantiate()
	get_tree().root.add_child(corpse)
	corpse.global_position = owner.global_position
	corpse.global_rotation = owner.global_rotation
	owner.queue_free()

func _on_health_died(actor: Actor) -> void:
	die()
