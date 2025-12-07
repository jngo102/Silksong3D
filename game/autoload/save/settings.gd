## Represents a settings file on the user's disk
class_name Settings extends Resource

@export var serialized_input: String

## The overall master volume
@export var master_volume: float = 1

## Volume of music in-game
@export var music_volume: float = 1

## Volume of sound effects in-game
@export var sfx_volume: float = 1

## The amount of screen shake
@export var screen_shake_intensity: float = 1

## The look sensitivity using the mouse
@export_range(0.1, 2) var look_sensitivity_mouse: float = 1

## The look sensitivity using the right analog joystick
@export_range(0.1, 2) var look_sensitivity_joystick: float = 1
