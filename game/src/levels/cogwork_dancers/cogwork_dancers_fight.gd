extends BaseLevel

@export var _doors: Array[Node3D]

func _on_door_close_trigger_body_entered(body: Node3D) -> void:
	if body is Player:
		for door in _doors:
			var door_animator: AnimationPlayer = door.get_node("Animator")
			door_animator.play(&"Close")
		$DoorCloseTrigger.queue_free()
