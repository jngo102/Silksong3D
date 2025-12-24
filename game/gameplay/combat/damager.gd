class_name Damager extends Area3D

@export var damage_amount: int = 1
@export var multi_hit: bool = false

@onready var collision: CollisionShape3D = $Collision

signal damaged(health: Health)
signal silk_given(amount: int)

func _on_area_entered(area: Area3D) -> void:
	if area is Health:
		damaged.emit(area)
		if area.give_silk:
			silk_given.emit(area.silk_amount)
