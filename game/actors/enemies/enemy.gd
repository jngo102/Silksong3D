class_name Enemy extends Actor

@onready var behavior_tree: BTPlayer = $BehaviorTree
@onready var health: Health = $Health

var bb: Blackboard:
	get:
		return behavior_tree.blackboard

func _on_health_took_damage(damage_amount: float) -> void:
	pass
	#create_tween().tween_property(mesh, "albedo_color", Color.WHITE, 0.5).from(Color.RED).set_trans(Tween.TRANS_CUBIC)
