class_name Corpse extends Node3D

@onready var _animator: AnimationPlayer = $Animator

var pieces: Array[CorpsePiece]:
	get:
		return get_children().filter(func(child: Node): child is CorpsePiece)

func _ready() -> void:
	_animator.play(&"Explode")
