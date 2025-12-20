class_name Actor extends CharacterBody3D

@onready var animator: AnimationPlayer = $Animator
@onready var _anim_tree: AnimationTree = animator.get_node_or_null("AnimationTree")
@onready var health: Health = $Health

func _process(delta: float) -> void:
	move_and_slide()

func face_target(target: Node3D) -> void:
	var angle: float = global_position.signed_angle_to(target.global_position, Vector3.UP)
	global_rotation.y = angle

func face_direction(direction: Vector3) -> void:
	var angle: float = atan2(-direction.z, direction.x)
	global_rotation.y = angle

func move(vector: Vector2) -> void:
	velocity = Vector3(vector.x, velocity.y, vector.y).rotated(Vector3.UP, global_rotation.y)
