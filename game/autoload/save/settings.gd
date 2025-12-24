## Represents a settings file on the user's disk
class_name Settings extends Resource

@export var serialized_input: String

## The amount of screen shake
@export var screen_shake_intensity: float = 1

## The overall master volume
@export var master_volume: float = 1:
	set(value):
		master_volume = value
		AudioServer.set_bus_volume_db(
			AudioServer.get_bus_index("Master"),
			linear_to_db(value))

## Volume of music in-game
@export var music_volume: float = 1:
	set(value):
		music_volume = value
		AudioServer.set_bus_volume_db(
			AudioServer.get_bus_index("Music"),
			linear_to_db(value))

## Volume of sound effects in-game
@export var sfx_volume: float = 1:
	set(value):
		sfx_volume = value
		AudioServer.set_bus_volume_db(
			AudioServer.get_bus_index("SFX"),
			linear_to_db(value))

@export var display_resolution := Vector2i(1920, 1080)

## The look sensitivity using the mouse
@export_range(0.1, 2) var look_sensitivity_mouse: float = 1

## Whether to invert the horizontal mouse look axis
@export var invert_mouse_x: bool = false

## Whether to invert the vertical mouse look axis
@export var invert_mouse_y: bool = false

## The look sensitivity using the right analog joystick
@export_range(0.1, 2) var look_sensitivity_joystick: float = 1

## Whether to invert the horizontal joystick  look axis
@export var invert_joystick_x: bool = false

## Whether to invert the vertical joystick look axis
@export var invert_joystick_y: bool = false
