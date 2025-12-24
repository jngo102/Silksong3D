class_name GameCamera extends Camera3D

@export var shake_interval: float = 0.025

## The position of the object before it began shaking
var original_position: Vector3
## The amount of shake to remove every frame
var unshake_amount: float
## The current shake vector applied to the object
var current_shake_vector: Vector3
## The current amount of shake applied to the object
var current_shake_magnitude: float
## The current time that the object has been offset for during a shake
var current_shake_time: float = INF

var _shake_timer: float = INF
var _shake_duration: float

var target: Node3D

var shaking: bool:
	get:
		return _shake_timer < _shake_duration

func _process(delta: float) -> void:
	_shake_timer += delta
	current_shake_time += delta
	if current_shake_time >= shake_interval and shaking:
		update_shake()

## Begin object shake in all directions
func shake(amount: float = 1, duration: float = 0.25, taper_off: bool = true) -> void:
	if shaking:
		return
	original_position = position
	current_shake_magnitude = amount * SaveManager.settings.screen_shake_intensity
	_shake_timer = 0
	current_shake_time = 0
	unshake_amount = (current_shake_magnitude / duration) if taper_off else 0
	_shake_duration = duration

## Update the current object shake
func update_shake() -> void:
	current_shake_vector = Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)).normalized() * current_shake_magnitude
	position = original_position + current_shake_vector
	if is_instance_valid(target):
		var direction: Vector3 = global_position.direction_to(target.global_position)
		look_at(target.global_position - current_shake_vector)
	current_shake_magnitude -= unshake_amount * current_shake_time
	current_shake_time = 0
