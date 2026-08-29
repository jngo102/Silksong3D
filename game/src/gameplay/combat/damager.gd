class_name Damager extends Area3D

@export var root: Node3D
@export var damage_amount: int = 1
@export var multi_hit: bool = false
@export var local_hit_direction: Vector3

@onready var collision: CollisionShape3D = $Collision

var hit_force: float:
	get:
		return local_hit_direction.length()

var global_hit_direction: Vector3:
	get:
		return root.global_basis * local_hit_direction.normalized()

signal damaged(health: Health)
signal silk_given(amount: int)

func _ready() -> void:
	if not is_instance_valid(root):
		root = owner

func _on_area_entered(area: Area3D) -> void:
	if area is Health:
		damaged.emit(area)
		if area.give_silk:
			silk_given.emit(area.silk_amount)
