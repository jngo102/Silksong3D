## A UI menu button that plays a click sound when pressed
class_name UIButton extends Button

@onready var _button_text: Label = $Elements/ButtonText
@onready var _fleur_animator: AnimationPlayer = $Elements/FleursAnimator
@onready var _flash_animator: AnimationPlayer = $Flash/FlashAnimator
@onready var _audio: AudioStreamPlayer = $ButtonAudio

## The audio when clicking the button
var click_sound: AudioStream = preload("uid://cksekixgpfns6")
var cancel_sound: AudioStream = preload("uid://dfdmaf8r0xoam")

func _ready() -> void:
	_button_text.text = text
	text = ""

func _on_pressed() -> void:
	_flash_animator.play(&"Flash")
	_audio.stream = click_sound
	_audio.play()

func _on_focus_entered() -> void:
	_fleur_animator.play(&"Show")

func _on_focus_exited() -> void:
	_fleur_animator.play(&"Hide")

func _on_mouse_entered() -> void:
	grab_focus()

func _on_mouse_exited() -> void:
	release_focus()
