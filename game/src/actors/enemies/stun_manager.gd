class_name StunManager extends Timer

@export var combo_time: float = 1
@export var health: Health
@export var stun_behavior_tree: BTPlayer
@export var stun_combo_hits: int = 10
@export var stun_max_hits: int = 15
@export var stun_effect_prefab: PackedScene

var _behavior_trees: Array[BTPlayer]

var _combo_counter: int
var _total_hit_counter: int

func _ready() -> void:
	for child in owner.find_children("*", "BTPlayer", true, true):
		if child is BTPlayer:
			_behavior_trees.append(child)
	
	timeout.connect(func():
		_combo_counter = 0
	)
	
	if is_instance_valid(health):
		health.took_damage.connect(_on_damage)

func _on_damage(damager: Damager) -> void:
	start(combo_time)
	_combo_counter += 1
	_total_hit_counter += 1
	if _combo_counter >= stun_combo_hits or _total_hit_counter >= stun_max_hits:
		_stun()

var _active_trees: Array[BTPlayer]

func _stun() -> void:
	health.took_damage.disconnect(_on_damage)
	
	var stun_effect = stun_effect_prefab.instantiate()
	add_child(stun_effect)
	stun_effect.global_position = owner.global_position
	_active_trees = _behavior_trees.filter(func(bt): return bt.active)
	for tree in _active_trees:
		if tree == stun_behavior_tree:
			continue
		tree.set_active(false)
	stun_behavior_tree.set_active(true)

func end_stun() -> void:
	health.took_damage.connect(_on_damage)
	
	_combo_counter = 0
	_total_hit_counter = 0
	
	stun_behavior_tree.set_active(false)
	for tree in _active_trees:
		if tree == stun_behavior_tree:
			continue
		tree.restart()
		tree.set_active(true)
