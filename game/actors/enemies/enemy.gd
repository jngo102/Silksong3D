class_name Enemy extends Actor

@onready var behavior_tree: BTPlayer = $BehaviorTree
@onready var target_point: VisibleOnScreenNotifier3D = $TargetPoint

var bb: Blackboard:
	get:
		return behavior_tree.blackboard

func _on_health_took_damage(damager: Damager) -> void:
	pass

func _on_target_point_screen_entered() -> void:
	add_to_group(&"Targetable")

func _on_target_point_screen_exited() -> void:
	remove_from_group(&"Targetable")
