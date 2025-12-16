class_name SpoolChunk extends Control

var chunk_index: int
var animation_index: int
var up: bool
var glow: bool

func _ready() -> void:
	animation_index = randi_range(1, 3)

func chunk_up() -> void:
	up = true

func chunk_down() -> void:
	up = false
