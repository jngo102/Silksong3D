class_name ParticlePreloader extends Node

@export var root: Node

var all_particles: Array[VisualInstance3D]:
	get:
		var particles: Array[VisualInstance3D] = []
		for child in root.find_children("*", "GPUParticles3D", true, true):
			if child is GPUParticles3D:
				particles.append(child)
		for child in root.find_children("*", "CPUParticles3D", true, true):
			if child is CPUParticles3D:
				particles.append(child)
		return particles

var longest_particle_lifetime: float:
	get:
		return all_particles.reduce(func(current_longest_lifetime: float, particles: VisualInstance3D):
			if particles is CPUParticles3D or particles is GPUParticles3D:
				if particles.lifetime > current_longest_lifetime:
					return particles.lifetime
				return current_longest_lifetime
			, 0)

func _ready() -> void:
	_preload()

func _preload() -> void:
	if not is_instance_valid(root):
		root = owner
	for particles in all_particles:
		if particles is GPUParticles3D:
			var original_process_mode: ProcessMode = particles.process_mode
			particles.position += Vector3.UP * 100
			particles.set_process_mode(ProcessMode.PROCESS_MODE_ALWAYS)
			particles.set_emitting(true)
			particles.set_emitting.call_deferred(false)
			particles.set_process_mode(original_process_mode)
			particles.position -= Vector3.UP * 100
		elif particles is CPUParticles3D:
			var original_process_mode: ProcessMode = particles.process_mode
			particles.position += Vector3.UP * 100
			particles.set_process_mode(ProcessMode.PROCESS_MODE_ALWAYS)
			particles.set_emitting(true)
			particles.set_emitting.call_deferred(false)
			particles.set_process_mode(original_process_mode)
			particles.position -= Vector3.UP * 100
	
