extends Node

var new_score: int
var old_score: int

var _current_level: BaseLevel
var _damage_taken: int
var _level_timer: float

func _ready() -> void:
	SceneManager.scene_changed.connect(_on_scene_change)

func _process(delta: float) -> void:
	_level_timer += delta

func calculate_score() -> void:
	if is_instance_valid(_current_level):
		new_score = _current_level.starting_score - _damage_taken * 1000 - floor(_level_timer * 100)
		SaveManager.save_data.high_scores[_current_level.name] = new_score

func _on_scene_change() -> void:
	if is_instance_valid(SceneManager.current_level):
		_set_up_level(SceneManager.current_level)

func _set_up_level(level: BaseLevel) -> void:
	if SaveManager.save_data.high_scores.has(level.name):
		old_score = SaveManager.save_data.high_scores[level.name]
	_current_level = level
	_damage_taken = 0
	_level_timer = 0
	var player: Player = level.player
	player.health.took_damage.connect(_on_player_took_damage)

func _on_player_took_damage(damager: Damager) -> void:
	if damager.multi_hit:
		_damage_taken += 1
	else:
		_damage_taken += damager.damage_amount
