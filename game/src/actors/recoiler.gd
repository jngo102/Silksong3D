class_name Recoiler extends Node3D

@export var body: CharacterBody3D
@export_range(0, 1000) var unrecoil_speed: float = 16

var _current_recoil_direction: Vector3
var _current_recoil_speed: float

func _process(delta: float) -> void:
	if _current_recoil_speed > 0:
		#print("RECOIL SPEED: ", _current_recoil_speed)
		body.move_and_collide(_current_recoil_direction * _current_recoil_speed * delta)
		_current_recoil_speed -= unrecoil_speed * delta

func recoil(direction: Vector3, speed: float) -> void:
	_current_recoil_direction = direction.normalized()
	_current_recoil_speed = speed
