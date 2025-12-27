## Base class for all levels in the game
class_name BaseLevel extends Node3D

## The music track played in this scene
@export var music_track: MusicTrack
@export var starting_score: int = 100000

@onready var player: Player = $Player
@onready var hud: HUD = $HUD
@onready var _bind_tip: HBoxContainer = $BindTip
@onready var _bind_icon: Button = _bind_tip.get_node_or_null("BindIcon")

var _score_screen: PackedScene = preload("uid://dcvpcta71mmie")

func _ready() -> void:
	_play_music()
	if not SaveManager.save_data.first_bind:
		_show_bind_tip()
		await get_tree().process_frame
		player.spool_manager.current_silk = player.spool_manager.bind_silk
		player.health.current_health -= 3

func _show_bind_tip() -> void:
	if InputManager.on_keys:
		var key_mouse_input: InputEvent = InputHelper.get_keyboard_input_for_action("Bind")
		if key_mouse_input is InputEventKey:
			_bind_icon.text = OS.get_keycode_string(key_mouse_input.keycode)
		elif key_mouse_input is InputEventMouseButton:
			var button_index: MouseButton = key_mouse_input.button_index
			match button_index:
				MOUSE_BUTTON_WHEEL_UP, \
				MOUSE_BUTTON_WHEEL_DOWN, \
				MOUSE_BUTTON_WHEEL_DOWN, \
				MOUSE_BUTTON_WHEEL_RIGHT:
					button_index = MOUSE_BUTTON_MIDDLE
			_bind_icon.text = InputHelper.get_label_for_input(key_mouse_input)
	else:
		var joypad_input: InputEvent = InputHelper.get_joypad_input_for_action("Bind")
		_bind_icon.text = InputHelper.get_label_for_input(joypad_input)
	_bind_tip.show()
	await player.health.healed
	_bind_tip.hide()
	SaveManager.save_data.first_bind = true

func _play_music() -> void:
	if music_track:
		AudioManager.play_music(music_track)

func finish() -> void:
	ScoreManager.calculate_score()
	await get_tree().create_timer(8, false).timeout
	SceneManager.change_scene( _score_screen)
