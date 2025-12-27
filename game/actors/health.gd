class_name Health extends Area3D

@export var max_health: int = 5
@export var _invincible: bool:
	set(value):
		_invincible = value
		if not value and is_instance_valid(_pulser):
			_pulser.stop_pulse()
		_collision.set_disabled.call_deferred(value)
@export var damage_invincibility_time: float = 0.5
@export var give_silk: bool = true
@export var silk_amount: int = 1
@export var damage_particles: Array[CPUParticles3D]
@export var damage_effect_prefab: PackedScene
@export var _flasher: Flasher
@export var _pulser: Pulser

@onready var _collision: CollisionShape3D = $Collision

signal took_damage(damager: Damager)
signal healed(amount: int)
signal health_changed(new_health: int)
signal died(actor: Actor)
signal multi_hit_started
signal multi_hit_ended

@onready var current_health: int = max_health:
	set(value):
		if current_health != value:
			health_changed.emit(value)
		current_health = value

var is_dead: bool:
	get:
		return current_health <= 0

var _invincibility_timer: float = -INF
var _invincibility_time: float = INF

func _process(delta: float) -> void:
	_update_invincibility_timer(delta)

func _update_invincibility_timer(delta: float) -> void:
	if not _invincible:
		return
	_invincibility_timer += delta
	if _invincibility_timer > _invincibility_time:
		set_invincible(false)

func take_damage(damager: Damager) -> void:
	current_health = max(0, current_health - damager.damage_amount)
	var direction: Vector3 = damager.global_position - global_position
	var angle: float = atan2(direction.z, -direction.x)
	for particles in damage_particles:
		particles.global_rotation.y = angle
		particles.restart()
	if is_instance_valid(damage_effect_prefab):
		var damage_effect: Node3D = damage_effect_prefab.instantiate()
		add_child(damage_effect)
		damage_effect.global_position = global_position
		damage_effect.global_rotation = owner.global_rotation
	if is_instance_valid(_flasher):
		_flasher.flash()
	elif is_instance_valid(_pulser):
		_pulser.start_pulse()
	took_damage.emit(damager)
	if current_health <= 0:
		_die()
	else:
		set_invincible(true, damage_invincibility_time)

func take_multi_hit_damage(damager: Damager) -> void:
	multi_hit_started.emit()
	set_invincible()
	var damage_left: int = damager.damage_amount
	for i in damager.damage_amount:
		damage_left -= 1
		current_health = max(0, current_health - 1)
		took_damage.emit(damager)
		if current_health <= 0:
			_die()
			return
		if damage_left > 0:
			await get_tree().create_timer(0.4, false).timeout
		else:
			multi_hit_ended.emit()
			if is_instance_valid(_flasher):
				_flasher.flash()
			elif is_instance_valid(_pulser):
				_pulser.start_pulse()
			set_invincible(true, damage_invincibility_time)

func set_invincible(invincible: bool = true, duration: float = INF) -> void:
	_invincibility_timer = 0
	_invincibility_time = duration
	_invincible = invincible

func heal(amount: int) -> void:
	current_health = min(current_health + amount, max_health)
	healed.emit(current_health)

func _die() -> void:
	if is_instance_valid(_pulser):
		_pulser.stop_pulse()
	set_invincible()
	died.emit(owner)

func _on_area_entered(area: Area3D) -> void:
	if not _invincible and area is Damager:
		if area.multi_hit:
			take_multi_hit_damage(area)
		else:
			take_damage(area)
