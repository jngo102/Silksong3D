class_name HealthPiece extends Control

@onready var _anim_tree: AnimationTree = $AnimationTree

var health: Health

var health_index: int

var broken: bool

func _ready() -> void:
	health.took_damage.connect(func(_damager):
		if health.current_health <= health_index:
			break_piece())
	health.healed.connect(func(_damager):
		if health.current_health > health_index:
			refill())

func break_piece() -> void:
	broken = true

func refill() -> void:
	broken = false
