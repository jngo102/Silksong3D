class_name Cursor extends Control

const MARGIN := Vector2(48, 16)

@onready var _animator: AnimationPlayer = $Animator
@onready var _light_effect: Control = $LightEffect

func _ready() -> void:
	move_to(get_parent())

func move_to(control: Control, immediate: bool = false) -> void:
	get_parent().remove_child.call_deferred(self)
	control.add_child.call_deferred(self)
	var new_size: Vector2 = control.size + MARGIN
	var new_position: Vector2 = control.global_position
	if not immediate:
		_animator.play(&"Show")
		var cursor_tween: Tween = create_tween()
		cursor_tween.tween_property(_light_effect, "size", new_size, _animator.get_animation(&"Show").length) \
			.from(Vector2.ZERO) \
			.set_trans(Tween.TRANS_LINEAR)
		cursor_tween.parallel().tween_property(_light_effect, "global_position", new_position - MARGIN / 2, _animator.get_animation(&"Show").length) \
			.from(new_position + new_size / 2) \
			.set_trans(Tween.TRANS_LINEAR)
	else:
		
		_animator.play(&"Show", 0, 0, true)
		_light_effect.size = new_size
		_light_effect.global_position = new_position
