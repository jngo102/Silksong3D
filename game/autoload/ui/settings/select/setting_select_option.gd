class_name SettingSelectOption extends Button

@export var _setting_name: String
@export var _options: Dictionary[StringName, Variant]

@onready var _animator: AnimationPlayer = $Animator
@onready var _contents: HBoxContainer = $Select/Contents
@onready var _setting_label: Label = _contents.get_node_or_null("SettingLabel")
@onready var _value_label: Label = _contents.get_node_or_null("ValueLabel")

signal value_changed(new_value: Variant)

var current_option: Variant:
	set(value):
		current_option = value
		var option_index: int = _options.values().find(value)
		if option_index >= 0:
			_value_label.text = _options.keys()[option_index]
		value_changed.emit(value)

func _ready() -> void:
	_setting_label.text = _setting_name

func _on_focus_entered() -> void:
	_animator.play(&"Focus")

func _on_focus_exited() -> void:
	_animator.play(&"Focus", 0, -1)

func _on_pressed() -> void:
	var option_index: int = _options.values().find(current_option)
	option_index = (option_index + 1) % len(_options)
	current_option = _options.values()[option_index]
