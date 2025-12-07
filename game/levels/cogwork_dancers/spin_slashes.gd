class_name SpinSlashes extends Node3D

@onready var animator: AnimationPlayer = $Animator

func play_antic() -> void:
	animator.play(&"Spin Antic")

func reset() -> void:
	animator.play(&"RESET")

func play_slashes() -> void:
	animator.play(&"Slashes")
