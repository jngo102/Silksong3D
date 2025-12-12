extends Node3D

@export_range(1, 4) var starting_phase: int = 1

var boss_phase: int:
	set(value):
		boss_phase = value
		if music_list.has(value):
			AudioManager.current_track = music_list[value]
		if is_instance_valid(dancer1):
			bb1.set_var(&"phase", value)
			death_bb1.set_var(&"phase", value)
		if is_instance_valid(dancer2):
			bb2.set_var(&"phase", value)
			death_bb2.set_var(&"phase", value)

@export var music_list: Dictionary[int, MusicTrack]

@export var starting_waypoint1: Marker3D
@export var starting_waypoint2: Marker3D
@export var alcove1: Marker3D
@export var alcove2: Marker3D

@export var measures_between_special_attacks: float = 16

@export var dashers: Array[CogworkDasher]

@onready var spinner: Spinner = $Spinner
@onready var spin_target1: Marker3D = spinner.get_node_or_null("DancerSpinTarget1")
@onready var dancer1: CogworkDancer = spin_target1.get_node_or_null("Dancer1")
@onready var spin_target2: Marker3D = spinner.get_node_or_null("DancerSpinTarget2")
@onready var dancer2: CogworkDancer = spin_target2.get_node_or_null("Dancer2")
@onready var spin_slashes: SpinSlashes = $SpinSlashes
@onready var teleport_point: Marker3D = $TeleportPoint

var _death_sting: AudioStream = preload("uid://dgm0v55whcadv")

var bb1: Blackboard:
	get:
		if not is_instance_valid(dancer1):
			return null
		return dancer1.bb

var bb2: Blackboard:
	get:
		if not is_instance_valid(dancer2):
			return null
		return dancer2.bb

var death_bb1: Blackboard:
	get:
		if not is_instance_valid(dancer1):
			return null
		return dancer1.death_bb

var death_bb2: Blackboard:
	get:
		if not is_instance_valid(dancer2):
			return null
		return dancer2.death_bb

var still_appearing: bool:
	get:
		return dashers.any(func(dasher: CogworkDasher):
			return dasher.still_appearing
		)

var measure_length: float:
	get:
		if is_instance_valid(AudioManager.current_track):
			return 60.0 / AudioManager.current_track.bpm
		return INF

var special_attack_delay: float:
	get:
		return measures_between_special_attacks * measure_length

var _special_attack_timer: float
var _waypoints: Array[Node]
var _waypoint1: Node3D
var _waypoint2: Node3D

func _ready() -> void:
	boss_phase = starting_phase
	AudioManager.current_track = music_list[boss_phase]
	dancer1.global_position = alcove1.global_position
	dancer2.global_position = alcove2.global_position
	dancer1.health.died.connect(_on_dancer_death)
	dancer2.health.died.connect(_on_dancer_death)
	_reset_default_blackboard_variables(dancer1)
	_reset_default_blackboard_variables(dancer2)
	_reset_death_blackboard_variables(dancer1)
	_reset_death_blackboard_variables(dancer2)
	_reset_special_attack_time()
	_waypoints = get_tree().get_nodes_in_group("Waypoints")

func _process(delta: float) -> void:
	var animation_index: int = randi_range(1, 6)
	if is_instance_valid(bb1):
		bb1.set_var(&"animation_index", animation_index)
	if is_instance_valid(bb2):
		bb2.set_var(&"animation_index", animation_index)
	if not AudioManager.current_music_player.playing:
		return
	_special_attack_timer += delta
	if _special_attack_timer >= special_attack_delay:
		_reset_special_attack_time()
		var special_attacks: Array[Callable] = [_set_up_teleport, _set_up_spin]
		if boss_phase == 4:
			# Remove teleport attack in lone phase
			special_attacks.remove_at(0)
		var special_attack: Callable = special_attacks.pick_random()
		special_attack.call()

func set_dancer_default_active(dancer: CogworkDancer) -> void:
	_reset_default_blackboard_variables(dancer)
	dancer.death_behavior_tree.set_active(false)
	dancer.behavior_tree.set_active(true)
	dancer.behavior_tree.restart()

func _reset_default_blackboard_variables(dancer: CogworkDancer) -> void:
	dancer.bb.set_var(&"phase", boss_phase)
	dancer.bb.set_var(&"manager_path", get_path())
	dancer.bb.set_var(&"manager_path", get_path())
	dancer.bb.set_var(&"spin_slashes_path", spin_slashes.get_path())
	dancer.bb.set_var(&"spin_slashes_path", spin_slashes.get_path())
	dancer.bb.set_var(&"spinner", spinner)
	dancer.bb.set_var(&"spinner", spinner)
	dancer.bb.set_var(&"spinner_path", spinner.get_path())
	dancer.bb.set_var(&"spinner_path", spinner.get_path())
	dancer.bb.set_var(&"teleport_point", teleport_point)
	dancer.bb.set_var(&"teleport_point", teleport_point)
	if dancer == dancer1:
		bb1.set_var(&"next_waypoint", starting_waypoint1)
		bb1.set_var(&"other_dancer", dancer2)
		bb1.set_var(&"other_dancer_next_waypoint", dancer2.behavior_tree.blackboard.get_var(&"next_waypoint"))
		bb1.set_var(&"spin_target", spin_target1)
		bb1.set_var(&"self", dancer1)
		bb1.set_var(&"direction_light", dancer1.get_node("Direction"))
	elif dancer == dancer2:
		bb2.set_var(&"next_waypoint", starting_waypoint2)
		bb2.set_var(&"other_dancer", dancer1)
		bb2.set_var(&"other_dancer_next_waypoint", dancer1.behavior_tree.blackboard.get_var(&"next_waypoint"))
		bb2.set_var(&"spin_target", spin_target2)
		bb2.set_var(&"self", dancer2)
		bb2.set_var(&"direction_light", dancer2.get_node("Direction"))

func _set_dancer_death_active(died_dancer: CogworkDancer) -> void:
	if is_instance_valid(dancer1):
		_reset_death_blackboard_variables(dancer1)
		dancer1.behavior_tree.set_active(false)
		dancer1.death_behavior_tree.set_active(true)
		dancer1.death_behavior_tree.restart()
		bb1.set_var(&"should_spin", false)
		bb1.set_var(&"should_teleport", false)
	if is_instance_valid(dancer2):
		_reset_death_blackboard_variables(dancer2)
		dancer2.behavior_tree.set_active(false)
		dancer2.death_behavior_tree.set_active(true)
		dancer2.death_behavior_tree.restart()
		bb2.set_var(&"should_spin", false)
		bb2.set_var(&"should_teleport", false)
	died_dancer.death_bb.set_var(&"fall", true)
	if boss_phase >= 3:
		died_dancer.death_bb.set_var(&"final_death", true)

func _reset_death_blackboard_variables(dancer: CogworkDancer) -> void:
	dancer.death_bb.set_var(&"manager_path", get_path())
	if dancer == dancer1:
		death_bb1.set_var(&"self", dancer1)
		death_bb1.set_var(&"alcove", alcove1)
	elif dancer == dancer2:
		death_bb2.set_var(&"self", dancer2)
		death_bb2.set_var(&"alcove", alcove2)

func increment_phase() -> void:
	boss_phase += 1

func play_music() -> void:
	AudioManager.play_music(music_list[boss_phase], 0, true)

func request_next_waypoint(requesting_dancer: CogworkDancer) -> Node:
	if requesting_dancer == dancer1:
		var current_waypoint: Node3D = bb1.get_var(&"current_waypoint")
		var other_current_waypoint: Node3D
		if is_instance_valid(bb2):
			other_current_waypoint = bb2.get_var(&"current_waypoint")
		_waypoint1 = _waypoints.pick_random()
		while _waypoint1 == _waypoint2 or _waypoint1 == current_waypoint or \
			(is_instance_valid(other_current_waypoint) and _waypoint1 == other_current_waypoint) or \
			dancer1.global_position.distance_to(_waypoint1.global_position) < 8:
			_waypoint1 = _waypoints.pick_random()
		return _waypoint1
	elif requesting_dancer == dancer2:
		var current_waypoint: Node3D = bb2.get_var(&"current_waypoint")
		var other_current_waypoint: Node3D
		if is_instance_valid(bb1):
			other_current_waypoint = bb1.get_var(&"current_waypoint")
		_waypoint2 = _waypoints.pick_random()
		while _waypoint2 == _waypoint1 or _waypoint2 == current_waypoint or \
			(is_instance_valid(other_current_waypoint) and _waypoint2 == other_current_waypoint) or \
			dancer2.global_position.distance_to(_waypoint2.global_position) < 8:
			_waypoint2 = _waypoints.pick_random()
		return _waypoint2
	return _waypoints.pick_random()

func set_ready_for_special_attack(dancer: CogworkDancer, dancer_ready: bool) -> void:
	if dancer == dancer1 and is_instance_valid(bb2):
		bb2.set_var(&"other_dancer_ready_for_special_attack", dancer_ready)
	elif dancer == dancer2 and is_instance_valid(bb1):
		bb1.set_var(&"other_dancer_ready_for_special_attack", dancer_ready)

func _reset_special_attack_time() -> void:
	_special_attack_timer = 0

func _set_up_spin() -> void:
	if is_instance_valid(bb1):
		bb1.set_var(&"should_spin", true)
	if is_instance_valid(bb2):
		bb2.set_var(&"should_spin", true)

func _set_up_teleport() -> void:
	if is_instance_valid(bb1):
		bb1.set_var(&"should_teleport", true)
	if is_instance_valid(bb2):
		bb2.set_var(&"should_teleport", true)

func start_dashing() -> void:
	for dasher in dashers:
		dasher.appear()
	while still_appearing:
		await get_tree().process_frame
	for dasher in dashers:
		dasher.dash()

func still_dashing() -> bool:
	return dashers.any(func(dasher: CogworkDasher):
		return not dasher.finished_dashing
	)

func _on_dancer_death(dancer: Actor) -> void:
	if boss_phase >= 3:
		measures_between_special_attacks = 8
	_reset_special_attack_time()
	AudioManager.stop_music()
	AudioManager.play_clip(_death_sting, Vector3.ZERO, 1, 1, 1, 1000)
	_set_dancer_death_active(dancer)
	boss_phase += 1
