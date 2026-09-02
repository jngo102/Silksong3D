class_name MeshFader extends Node

@export var _meshes: Array[MeshInstance3D]

var _materials: Array[BaseMaterial3D]

func _ready() -> void:
	for mesh_instance in _meshes:
		var mesh: Mesh = mesh_instance.mesh
		for surface_index in mesh.get_surface_count():
			var surface_material: BaseMaterial3D = mesh_instance.get_active_material(surface_index)
			surface_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
			surface_material.cull_mode = BaseMaterial3D.CULL_DISABLED
			_materials.append(surface_material)

func fade(duration: float = 0.25, from: float = 1.0, to: float = 0.0) -> void:
	var fade_tween: Tween = create_tween()
	for material in _materials:
		fade_tween.parallel().tween_property(material, "albedo_color:a", to, duration).from(from)
	await get_tree().create_timer(duration, false).timeout

func reset() -> void:
	for material in _materials:
		material.albedo_color.a = 1.0
