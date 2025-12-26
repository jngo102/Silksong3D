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
var _initial_offset: Vector3

var targets: Array[Node3D]
var valid_targets: Array[Node3D]:
	get:
		return targets.filter(func(target):
			return is_instance_valid(target))
var target_count: int:
	get:
		return len(valid_targets)
var midpoint: Vector3:
	get:
		var point := Vector3.ZERO
		if target_count > 0:
			for target in valid_targets:
				if is_instance_valid(target):
					midpoint += target.global_position
			point /= target_count
		return point

var shaking: bool:
	get:
		return _shake_timer < _shake_duration

func _ready() -> void:
	_initial_offset = position

func _process(delta: float) -> void:
	_shake_timer += delta
	current_shake_time += delta
	if current_shake_time >= shake_interval and shaking:
		update_shake()
	if target_count > 1:
		var others_midpoint := Vector3.ZERO
		var main_target: Node3D = valid_targets[0]
		for target in valid_targets:
			if target == main_target:
				continue
			others_midpoint += target.global_position
		others_midpoint /= target_count
		look_at(others_midpoint)
	elif target_count == 1:
		look_at(valid_targets[-1].global_position)

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
	var direction: Vector3 = global_position.direction_to(midpoint)
	look_at(midpoint - current_shake_vector)
	global_rotation.z = 0
	current_shake_magnitude -= unshake_amount * current_shake_time
	current_shake_time = 0
