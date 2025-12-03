class_name Actor extends CharacterBody3D

@onready var _animator: AnimationPlayer = $Animator
@onready var _anim_tree: AnimationTree = _animator.get_node_or_null("AnimationTree")
