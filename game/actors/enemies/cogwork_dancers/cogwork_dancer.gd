class_name CogworkDancer extends Enemy

@export var top: bool

var other_dancer: CogworkDancer

var bb: Blackboard:
	get:
		return behavior_tree.blackboard

func _ready() -> void:
	bb.set_var("top", top)

func get_other_dancer_next_waypoint() -> Node3D:
	return other_dancer.behavior_tree.blackboard.get_var(&"next_waypoint")

func validate_next_waypoint() -> bool:
	var current_waypoint: Node3D =  bb.get_var(&"current_waypoint")
	var next_waypoint: Node3D =  bb.get_var(&"next_waypoint")
	var other_dancer_next_waypoint: Node3D = other_dancer.bb.get_var(&"next_waypoint")
	return next_waypoint != current_waypoint and next_waypoint != other_dancer_next_waypoint
