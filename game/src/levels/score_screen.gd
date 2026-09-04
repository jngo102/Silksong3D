class_name ScoreScreen extends Control

@onready var _animator: AnimationPlayer = $Animator
@onready var _contents: VBoxContainer = $Contents
@onready var _score_label: Label = _contents.get_node_or_null("Score")
@onready var _new_high_score_label: Label = _contents.get_node_or_null("NewHighScoreLabel")

func _ready() -> void:
	_score_label.text = str(ScoreManager.new_score)
	await _animator.animation_finished
	if ScoreManager.new_score > ScoreManager.old_score:
		_animator.play(&"New High Score")
		await _animator.animation_finished
	_animator.play(&"Show Prompt")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_cancel") or event.is_action_pressed(&"ui_accept"):
		SceneManager.go_to_main_menu()
