## Full screen blanker for transitioning between scenes
class_name Fader extends BaseUI
## Displays when transitioning between screens

## Emitted when the screen finishes transitioning in
signal faded_in
## Emitted when the screen finishes transitioning out
signal faded_out

## Controls the transition in and transition out animations
@onready var animator: AnimationPlayer = $Animator

func open() -> void:
	super.open()
	animator.play(&"Fade In")

func close() -> void:
	animator.play(&"Fade Out")

func _on_animator_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		&"Fade In":
			faded_in.emit()
		&"Fade Out":
			super.close()
			faded_out.emit()
