class_name HealthPiece extends Control

@onready var _anim_tree: AnimationTree = $AnimationTree

var health: Health

var health_index: int

var broken: bool

func _ready() -> void:
	if health.current_health <= health_index:
		var fsm: AnimationNodeStateMachinePlayback = _anim_tree.get("parameters/playback")
		broken = true
		fsm.start("Empty", true)
	health.health_changed.connect(func(new_health: int):
		if new_health > health_index:
			refill()
		else:
			break_piece())

func break_piece() -> void:
	broken = true

func refill() -> void:
	broken = false
