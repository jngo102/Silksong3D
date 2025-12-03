class_name Enemy extends Actor

@onready var _dancer_mesh: MeshInstance3D = $Model/Armature/Skeleton3D/Dancer

var mesh: ArrayMesh:
	get:
		return _dancer_mesh.mesh

func _on_health_took_damage(damage_amount: float) -> void:
	pass
	#create_tween().tween_property(mesh, "albedo_color", Color.WHITE, 0.5).from(Color.RED).set_trans(Tween.TRANS_CUBIC)
