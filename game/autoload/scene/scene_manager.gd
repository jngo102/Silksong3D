## Manages loading and unloading of scenes
extends Node

## All loaded scenes, including ones not currently attached to the scene tree
var loaded_scenes: Array[BaseLevel]

signal scene_changed

## The currently-loaded level
var current_level: BaseLevel:
	get:
		var scene: Node = get_tree().current_scene
		if scene is BaseLevel:
			return scene
		return null

var _main_menu_scene: PackedScene = preload("uid://d0nkpdyoqawun")

func _ready() -> void:
	get_tree().root.size = SaveManager.settings.display_resolution
	set_process_mode(PROCESS_MODE_ALWAYS)

## Generic scene change function
func change_scene(scene: PackedScene) -> void:
	var fader: Fader = UIManager.open_ui(Fader)
	await fader.faded_in
	get_tree().change_scene_to_packed(scene)
	await get_tree().process_frame
	scene_changed.emit()
	fader.close()
	await fader.faded_out

func reload() -> void:
	change_scene(load(current_level.scene_file_path))

func go_to_main_menu() -> void:
	change_scene(_main_menu_scene)
