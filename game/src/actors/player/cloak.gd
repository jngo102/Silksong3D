@tool
extends SoftBody3D

@export var _collar_height_y: float = 3.5
@export_node_path("BoneAttachment3D") var _attachment_point_path: NodePath

func _ready() -> void:
	var points: PackedVector3Array =  mesh.surface_get_arrays(0)[Mesh.ARRAY_VERTEX]
	for point_index in range(0, len(points)):
		var point: Vector3 = points[point_index]
		set_point_pinned(point_index, point.y > _collar_height_y, _attachment_point_path)
			
