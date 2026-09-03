class_name ParticlePreloader extends Node

@export var root: Node

func _ready() -> void:
	_preload()

func _preload() -> void:
	if not is_instance_valid(root):
		root = owner
	root.position += Vector3.UP * 1000
	for child in root.find_children("*", "GPUParticles3D", true, true):
		if child is GPUParticles3D:
			var original_process_mode: ProcessMode = child.process_mode
			child.set_process_mode(ProcessMode.PROCESS_MODE_ALWAYS)
			child.set_emitting(true)
			child.set_emitting.call_deferred(false)
			child.set_process_mode(original_process_mode)
	for child in root.find_children("*", "CPUParticles3D", true, true):
		if child is CPUParticles3D:
			var original_process_mode: ProcessMode = child.process_mode
			child.set_process_mode(ProcessMode.PROCESS_MODE_ALWAYS)
			child.set_emitting(true)
			child.set_emitting.call_deferred(false)
			child.set_process_mode(original_process_mode)
	root.position -= Vector3.UP * 1000
