class_name Flasher extends Node

@export var _meshes: Array[MeshInstance3D]

var _materials: Array[BaseMaterial3D]

func _ready() -> void:
	for mesh_instance in _meshes:
		var mesh: Mesh = mesh_instance.mesh
		for surface_index in mesh.get_surface_count():
			var surface_material: BaseMaterial3D = mesh_instance.get_active_material(surface_index)
			if surface_material.emission_energy_multiplier > 1:
				# Don't modify materials that already have emission enabled
				continue
			surface_material.emission_enabled = true
			surface_material.emission = Color.WHITE
			surface_material.emission_energy_multiplier = 0
			_materials.append(surface_material)

func flash(from: float = 1, to: float = 0, duration: float = 0.25) -> void:
	var flash_tween: Tween = create_tween()
	for material in _materials:
		flash_tween.parallel().tween_property(material, "emission_energy_multiplier", to, duration).from(from)
