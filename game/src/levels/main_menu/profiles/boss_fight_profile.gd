class_name BossFightProfile extends Control

@onready var _animator: AnimationPlayer = $Animator
@onready var _arrows_animator: AnimationPlayer = $ArrowsAnimator
@onready var _thumbnail_button: Button = $Thumbnail
@onready var _high_score_label: Label = _thumbnail_button.get_node_or_null("HighScoreValue")
@onready var _name_label: Label = _thumbnail_button.get_node_or_null("Name")

var _select_audio: AudioStream = preload("uid://cksekixgpfns6")
var _enter_audio: AudioStream = preload("uid://dych7ifmqv8j0")

var data: BossFightProfileData

var still_showing: bool:
	get:
		return _animator.current_animation == &"Show" and _animator.is_playing()

func _ready() -> void:
	if is_instance_valid(data):
		_thumbnail_button.icon = data.thumbnail
		_name_label.text = data.boss_name
		if SaveManager.save_data.high_scores.has(data.root_node_name):
			_high_score_label.text = str(SaveManager.save_data.high_scores[data.root_node_name])
		else:
			_high_score_label.text = "0"

func show_profile() -> void:
	_animator.play(&"Show")
	await _animator.animation_finished

func hide_profile() -> void:
	_animator.play(&"Show", 0, -1, true)
	await _animator.animation_finished

func _on_thumbnail_focus_entered() -> void:
	_arrows_animator.play(&"Highlight")
	await _arrows_animator.animation_finished
	_arrows_animator.play(&"Highlighted")

func _on_thumbnail_focus_exited() -> void:
	_arrows_animator.play(&"Highlight", 0, -1, true)

func _on_thumbnail_mouse_entered() -> void:
	_thumbnail_button.grab_focus()

func _on_thumbnail_mouse_exited() -> void:
	_thumbnail_button.release_focus()

func _on_thumbnail_pressed() -> void:
	if is_instance_valid(data):
		AudioManager.play_clip(_select_audio, true)
		AudioManager.play_clip(_enter_audio, true)
		SceneManager.change_scene(data.scene)
