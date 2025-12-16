## A user interface with components that stack on 
## top of each other and may be navigated through
class_name StackableUI extends Control

## A list of all the child UIs that may be stacked
@export var child_uis: Array[Control]
## The default child UI to show when this UI is shown
@export var default_ui: Control

## Emiited when a UI is stacked to the top.
signal ui_stacked(ui: Control)
## Emitted when the top-most UI is popped off.
signal ui_popped(ui: Control)
## Emitted when all UIs in the stack have been popped
signal uis_emptied()

## The managed stack of active child UIs
var ui_stack: Array[Control]

func _ready() -> void:
	if not is_instance_valid(default_ui):
		if len(child_uis) > 0:
			default_ui = child_uis[0]
		else:
			return
	_stack(default_ui)
	for ui in child_uis:
		if ui != default_ui:
			ui.hide()
			ui.hidden.connect(check_empty)
	visibility_changed.connect(_on_visibility_changed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_back"):
		pop()

## Stack a user interface on the top of the stack
func _stack(ui: Control) -> void:
	if len(ui_stack) > 0:
		var topmost_ui: Control = ui_stack[-1]
		var fade_tween: Tween = create_tween()
		fade_tween.tween_property(topmost_ui, "modulate", Color.TRANSPARENT, 0.25).from(Color.WHITE)
		fade_tween.tween_callback(topmost_ui.hide)
		await fade_tween.finished
	var fade_tween: Tween = create_tween()
	fade_tween.tween_property(ui, "modulate", Color.WHITE, 0.15).from(Color.TRANSPARENT)
	# Prevent flicker when showing for the first time
	await get_tree().process_frame
	ui.show()
	await fade_tween.finished
	ui_stack.push_back(ui)
	ui_stacked.emit(ui)

## Pop off the top-most UI in the stack
func pop() -> void:
	if len(ui_stack) <= 1:
		uis_emptied.emit()
	else:
		check_empty()

## Show the topmost UI if one is available
func check_empty() -> void:
	if len(ui_stack) > 1:
		var topmost_ui: Control = ui_stack.pop_back()
		var fade_tween: Tween = create_tween()
		fade_tween.tween_property(topmost_ui, "modulate", Color.TRANSPARENT, 0.25).from(Color.WHITE)
		fade_tween.tween_callback(topmost_ui.hide)
		ui_popped.emit(topmost_ui)
		var next_ui: Control = ui_stack.back()
		fade_tween.tween_property(next_ui, "modulate", Color.WHITE, 0.25).from(Color.TRANSPARENT)
		# Prevent flicker when showing for the first time
		await get_tree().process_frame
		next_ui.show()

func _on_visibility_changed() -> void:
	if visible:
		grab_focus()
