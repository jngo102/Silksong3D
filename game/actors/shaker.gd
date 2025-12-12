## Controls shaking of an object
class_name Shaker extends Node

## The duration between each shake
@export var shake_interval: float = 0.025

## The position of the object before it began shaking
var original_position: Vector3
## The amount of shake to remove every frame
var unshake_amount: float
## Whether to shake along the x-axis
var shake_horizontally: bool
## Whether to shake along the y-axis
var shake_vertically: bool
## The current shake vector applied to the object
var current_shake_vector: Vector3
## The current amount of shake applied to the object
var current_shake_magnitude: float
## The current time that the object has been offset for during a shake
var current_shake_time: float
## Whether to shake the object in place
var shake_in_place: bool
var _shake_timer: float
var _shake_duration: float

var _shaking: bool

func _process(delta: float) -> void:
	if _shake_timer < _shake_duration:
		_shake_timer += delta
		current_shake_time += delta
		if current_shake_time >= shake_interval:
			update_shake()
	elif _shaking:
		_shaking = false
		if shake_in_place:
			owner.global_position = original_position

## Set shake values
func _shake_internal(amount: float, duration: float, in_place: bool = false, taper_off: bool = true) -> void:
	original_position = owner.global_position
	current_shake_magnitude = amount
	if shake_horizontally:
		current_shake_vector.x = 1
	if shake_vertically:
		current_shake_vector.y = 1
	unshake_amount = amount / duration if taper_off else 0
	shake_in_place = in_place
	_shake_duration = duration
	_shake_timer = 0
	_shaking = true

## Begin object shake in all directions
func shake(amount: float, duration: float, in_place: bool = false, taper_off: bool = true) -> void:
	_shake_internal(amount, duration, in_place, taper_off)
	shake_horizontally = true
	shake_vertically = true

## Shake object only along the x-axis	
func shake_x(amount: float, duration, in_place: bool = false) -> void:
	_shake_internal(amount, duration, in_place)
	shake_horizontally = true
	shake_vertically = false

## Shake object only along the y-axis	
func shake_y(amount: float, duration, in_place: bool = false) -> void:
	_shake_internal(amount, duration, in_place)
	shake_horizontally = false
	shake_vertically = true

## Update the current object shake
func update_shake() -> void:
	if shake_horizontally and shake_vertically:
		current_shake_vector = Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)).normalized() * current_shake_magnitude
	if shake_horizontally and not shake_vertically:
		current_shake_vector.x = current_shake_magnitude * -sign(current_shake_vector.x)
	elif not shake_horizontally and shake_vertically:
		current_shake_vector.y = current_shake_magnitude * -sign(current_shake_vector.y)
	if shake_in_place:
		owner.global_position = original_position + current_shake_vector
	else:
		owner.global_position += current_shake_vector
	current_shake_magnitude -= unshake_amount * current_shake_time
	current_shake_time = 0
