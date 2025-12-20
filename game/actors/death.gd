class_name Death extends Node

@export var health: Health
@export var corpse_prefab: PackedScene
@export var special_death: bool
@export var death_pause_duration: float = 0

func _ready() -> void:
	if not special_death:
		health.died.connect(func(_actor):
			die())

func die() -> void:
	if death_pause_duration > 0:
		TimeManager.stop_time(true, death_pause_duration)
	if is_instance_valid(corpse_prefab):
		var corpse: Node3D = corpse_prefab.instantiate()
		get_tree().root.add_child(corpse)
		corpse.global_position = owner.global_position
		corpse.global_rotation = owner.global_rotation
	owner.queue_free()
	for damager in NodeUtil.find_all_children_of_type(owner, Damager):
		if damager is Damager:
			damager.collision.set_disabled.call_deferred(true)

func revive(new_health: int) -> void:
	health.current_health = new_health
