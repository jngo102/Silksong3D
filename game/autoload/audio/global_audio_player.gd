class_name AudioPlayer3D extends AudioStreamPlayer

func _on_finished() -> void:
	queue_free()
