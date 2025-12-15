class_name BossFightProfile extends Control

@onready var _animator: AnimationPlayer = $Animator
@onready var _thumbnail_button: Button = $Thumbnail
@onready var _name_label: Label = _thumbnail_button.get_node_or_null("Name")

var data: BossFightProfileData

var still_showing: bool:
	get:
		return _animator.current_animation == &"Show" and _animator.is_playing()

func _ready() -> void:
	if is_instance_valid(data):
		_thumbnail_button.icon = data.thumbnail
		_name_label.text = data.boss_name

func show_profile() -> void:
	_animator.play(&"Show")
	await _animator.animation_finished

func hide_profile() -> void:
	_animator.play(&"Show", 0, -1, true)
	await _animator.animation_finished

func _on_thumbnail_focus_entered() -> void:
	_animator.play(&"RESET")
	_animator.play(&"Highlight")
	await _animator.animation_finished
	_animator.play(&"Highlighted")

func _on_thumbnail_focus_exited() -> void:
	_animator.play(&"RESET")
	_animator.play(&"Highlight", 0, -1, true)

func _on_thumbnail_mouse_entered() -> void:
	_thumbnail_button.grab_focus()

func _on_thumbnail_mouse_exited() -> void:
	_thumbnail_button.release_focus()

func _on_thumbnail_pressed() -> void:
	if is_instance_valid(data):
		$SelectProfileAudio.play()
		SceneManager.change_scene(data.scene)
