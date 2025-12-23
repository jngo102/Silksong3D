## Manages loading and unloading of scenes
extends Node

## The screen that levels are rendered to
@onready var screen: SubViewport = get_node("/root/Main/ScreenContainer/Screen")

## Emitted whenever a scene changes
signal scene_changed(new_scene_name: String)

## All loaded scenes, including ones not currently attached to the scene tree
var loaded_scenes: Array[BaseLevel]

## The currently-loaded level
var current_level: BaseLevel:
	get:
		return screen.get_child(0)

var _main_menu_scene: PackedScene = preload("uid://d0nkpdyoqawun")

## Generic scene change function
func change_scene(scene: PackedScene) -> void:
	var fader: Fader = UIManager.open_ui(Fader)
	await fader.faded_in
	current_level.queue_free()
	await get_tree().process_frame
	var level = scene.instantiate()
	screen.add_child(level)
	scene_changed.emit(level.name)
	fader.close()
	await fader.faded_out

## Reload the current scene
func reload() -> void:
	change_scene(load(current_level.scene_file_path))

func go_to_main_menu() -> void:
	change_scene(_main_menu_scene)
