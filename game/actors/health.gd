class_name Health extends Area3D

@export var max_health: int = 5
@export var _invincible: bool:
	get:
		return _collision.disabled
	set(value):
		_collision.set_disabled.call_deferred(value)
@export var damage_invincibility_time: float = 0.5
@export var give_silk: bool = true
@export var silk_amount: int = 1
@export var damage_particles: Array[CPUParticles3D]
@export var damage_effect_prefab: PackedScene
@export var _flasher: Flasher

@onready var _collision: CollisionShape3D = $Collision

signal took_damage(damager: Damager)
signal healed(amount: int)
signal died(actor: Actor)

@onready var current_health: int = max_health

var is_dead: bool:
	get:
		return current_health <= 0

var _invincibility_timer: float = -INF

func _process(delta: float) -> void:
	_update_invincibility_timer(delta)

func _update_invincibility_timer(delta: float) -> void:
	if not _invincible:
		return
	_invincibility_timer += delta
	if _invincibility_timer > damage_invincibility_time:
		set_invincible(false, 0)

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
	took_damage.emit(damager)
	if current_health <= 0:
		_die()
	else:
		set_invincible()
		_invincibility_timer = 0

func set_invincible(be_invincible: bool = true, duration: float = damage_invincibility_time) -> void:
	_invincible = be_invincible
	if be_invincible and duration > 0:
		await get_tree().create_timer(duration, false).timeout
		_invincible = false

func heal(amount: int) -> void:
	current_health = min(current_health + amount, max_health)
	healed.emit(current_health)

func _die() -> void:
	set_invincible(true, 0)
	_invincibility_timer = -INF
	died.emit(owner)

func _on_area_entered(area: Area3D) -> void:
	if area is Damager:
		take_damage(area)
