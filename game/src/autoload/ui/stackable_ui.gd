## A user interface with components that stack on 
## top of each other and may be navigated through
class_name StackableUI extends Control

# Child Controls that should not be factored into the stacking logic
@export var _excluded_uis: Array[Control]

@export var _cancel_sound: AudioStream = preload("uid://dfdmaf8r0xoam")

## A list of all the child UIs that may be stacked
@onready var _child_uis: Array[Control]:
	get:
		return get_children().filter(func(child):
			return child is Control and not _excluded_uis.has(child))

## The default UI to show when this UI is opened
@onready var _default_ui: Control:
	get:
		if len(_child_uis) > 0:
			return _child_uis[0]
		return null

@onready var _current_ui: Control:
	get:
		var child_index: int = _child_uis.find_custom(func(child):
			return child is Control and child.is_visible_in_tree())
		if child_index < 0:
			return null
		return _child_uis[child_index]

var _fade_tween: Tween

var _fading: bool:
	get:
		return is_instance_valid(_fade_tween) and _fade_tween.is_running()

@onready var _first_focusable: Control:
	get:
		if not is_instance_valid(_default_ui):
			return null
		var focusables: Array[Node] = find_children("*", "Control", true, false).filter(func(child: Control):
			return child is Control and child.focus_mode == FocusMode.FOCUS_ALL)
		if len(focusables) > 0:
			return focusables[0]
		return null
				

var _last_focused: Control

func _ready() -> void:
	_init_nodes()
	_connect_signals()
	_reset()

func _init_nodes() -> void:
	if not is_instance_valid(_last_focused):
		reset_focus()

func _connect_signals() -> void:
	get_viewport().gui_focus_changed.connect(_on_gui_focus_change)
	for child in _child_uis:
		if child == _default_ui:
			continue
		child.hidden.connect(_reset)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_back") and _current_ui == _default_ui and not _fading:
		hide_self()

## Stack a user interface on the top of the stack
func _show_child(ui: Control) -> void:
	if _fading:
		return
	if is_instance_valid(_current_ui):
		_fade_tween = UIManager.fade_out_ui(_current_ui)
		await _fade_tween.finished
		_current_ui.hide()
	_current_ui = ui
	if ui is StackableUI:
		await ui.show_self()
		ui.reset_focus()
	else:
		_fade_tween = UIManager.fade_in_ui(ui)
		ui.show()
		await _fade_tween.finished

func show_self() -> void:
	_fade_tween = UIManager.fade_in_ui(self)
	# Prevent flickering when child UI is fading in
	await get_tree().process_frame
	show()
	_reset()
	await _fade_tween.finished

func hide_self(play_sound: bool = true) -> void:
	if _fading:
		return
	if play_sound and is_instance_valid(_cancel_sound):
		AudioManager.play_clip(_cancel_sound, true, "UI")
	_fade_tween = UIManager.fade_out_ui(self)
	await _fade_tween.finished
	hide()
	_reset()

func _reset(immediate: bool = false) -> void:
	if not is_visible_in_tree():
		return
	for i in len(_child_uis):
		var ui: Control = _child_uis[i]
		if i > 0:
			ui.hide()
	if is_instance_valid(_default_ui):
		if not immediate:
			_fade_tween = UIManager.fade_in_ui(_default_ui)
			_default_ui.show()
			await _fade_tween.finished
	if is_instance_valid(_last_focused):
		_last_focused.grab_focus()

func reset_focus() -> void:
	_last_focused = _first_focusable

func _on_gui_focus_change(focused: Control) -> void:
	if not _default_ui.is_ancestor_of(focused):
		return
	_last_focused = focused
