class_name Health extends Area3D

@export var max_health: int = 5

@onready var _blood: GPUParticles3D = $BloodParticles

signal took_damage(damage_amount: float)

@onready var current_health: int = max_health

func take_damage(damager: Damager) -> void:
	current_health = max(0, current_health - damager.damage_amount)
	var direction: Vector3 = damager.global_position - global_position
	var angle: float = atan2(direction.z, -direction.x)
	_blood.rotation.y = angle
	_blood.restart()
	took_damage.emit(damager.damage_amount)
	if current_health <= 0:
		_die()

func _die() -> void:
	owner.queue_free()

func _on_area_entered(area: Area3D) -> void:
	if area is Damager:
		take_damage(area)
