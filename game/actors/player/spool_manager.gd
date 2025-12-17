class_name SpoolManager extends Node

@export var max_silk: int = 8
@export var bind_silk: int = 8

signal silk_changed(new_value: int)
signal bind_state_changed(can_bind: bool)

var current_silk: int:
	set(value):
		silk_changed.emit(value)
		if value >= bind_silk and current_silk < bind_silk:
			bind_state_changed.emit(true)
		elif value < bind_silk and current_silk >= bind_silk:
			bind_state_changed.emit(false)
		current_silk = value

func _ready() -> void:
	var damagers = NodeUtil.find_all_children_of_type(owner, Damager)
	for damager in damagers:
		if damager is Damager:
			damager.silk_given.connect(_on_silk_given)

func _on_silk_given(amount: int) -> void:
	current_silk += amount
