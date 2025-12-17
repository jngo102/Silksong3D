class_name Health extends Area3D

@export var max_health: int = 5
@export var invincible: bool:
	get:
		return _collision.disabled
	set(value):
		_collision.set_disabled.call_deferred(value)
@export var damage_invincibility_time: float = 0.5
@export var give_silk: bool = true
@export var silk_amount: int = 1
@export var damage_particles: Array[GPUParticles3D]

@onready var _collision: CollisionShape3D = $Collision

signal took_damage(damager: Damager)
signal healed(amount: int)
signal died(actor: Actor)

@onready var current_health: int = max_health

var _invincibility_timer: float

func _process(delta: float) -> void:
	_update_invincibility_timer(delta)

func _update_invincibility_timer(delta: float) -> void:
	if not invincible:
		return
	_invincibility_timer += delta
	if _invincibility_timer > damage_invincibility_time:
		invincible = false

func take_damage(damager: Damager) -> void:
	current_health = max(0, current_health - damager.damage_amount)
	var direction: Vector3 = damager.global_position - global_position
	var angle: float = atan2(direction.z, -direction.x)
	set_invincible()
	for particles in damage_particles:
		particles.rotation.y = angle
		particles.restart()
	took_damage.emit(damager)
	if current_health <= 0:
		_die()
	else:
		_invincibility_timer = 0

func set_invincible(be_invincible: bool = true, duration: float = damage_invincibility_time) -> void:
	invincible = true
	if duration > 0:
		await get_tree().create_timer(duration, false).timeout
		invincible = false

func heal(amount: int) -> void:
	current_health += amount
	healed.emit(amount)

func _die() -> void:
	invincible = true
	_invincibility_timer = -INF
	died.emit(owner)

func _on_area_entered(area: Area3D) -> void:
	if area is Damager:
		take_damage(area)
