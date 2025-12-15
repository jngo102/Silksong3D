class_name Corpse extends Node3D

@onready var _animator: AnimationPlayer = $Animator

var pieces: Array[CorpsePiece]:
	get:
		return get_children().filter(func(child: Node): child is CorpsePiece)

func _ready() -> void:
	var cam_shaker: Shaker = get_tree().get_first_node_in_group(&"Cameras").get_node("Shaker")
	cam_shaker.shake(1, 0.5)
