extends Node3D

@export_range(1, 4) var starting_phase: int = 1

var boss_phase: int:
	set(value):
		boss_phase = value
		AudioManager.play_music(music_list[value])

@export var music_list: Dictionary[int, MusicTrack]

@export var starting_waypoint1: Marker3D
@export var starting_waypoint2: Marker3D

@export var min_special_attack_delay: float = 8
@export var max_special_attack_delay: float = 12

@export var dashers: Array[CogworkDasher] 

@onready var spinner: Spinner = $Spinner
@onready var spin_target1: Marker3D = spinner.get_node_or_null("DancerSpinTarget1")
@onready var dancer1: CogworkDancer = spin_target1.get_node_or_null("Dancer1")
@onready var spin_target2: Marker3D = spinner.get_node_or_null("DancerSpinTarget2")
@onready var dancer2: CogworkDancer = spin_target2.get_node_or_null("Dancer2")
@onready var spin_slashes: SpinSlashes = $SpinSlashes
@onready var teleport_point: Marker3D = $TeleportPoiht

var blackboard1: Blackboard:
	get:
		return dancer1.behavior_tree.blackboard

var blackboard2: Blackboard:
	get:
		return dancer2.behavior_tree.blackboard

var still_appearing: bool:
	get:
		return dashers.any(func(dasher: CogworkDasher):
			return dasher.still_appearing
		)

var _special_attack_timer: float
var _special_attack_delay: float
var _waypoints: Array[Node]
var _waypoint1: Node
var _waypoint2: Node

func _ready() -> void:
	boss_phase = starting_phase
	dancer1.other_dancer = dancer2
	dancer2.other_dancer = dancer1
	dancer1.global_position = starting_waypoint1.global_position
	dancer2.global_position = starting_waypoint2.global_position
	_set_blackboard_variables()
	_reset_special_attack_time()
	AudioManager.current_music_player.finished.connect(_on_music_loop)
	_waypoints = get_tree().get_nodes_in_group("Waypoints")

func _process(delta: float) -> void:
	_special_attack_timer += delta
	if _special_attack_timer > _special_attack_delay:
		_reset_special_attack_time()
		var special_attack: Callable = [_set_up_teleport, _set_up_spin].pick_random()
		special_attack.call()
	var animation_index: int = randi_range(1, 6)
	blackboard1.set_var(&"animation_index", animation_index)
	blackboard2.set_var(&"animation_index", animation_index)

func _set_blackboard_variables() -> void:
	blackboard1.set_var(&"phase", boss_phase)
	blackboard2.set_var(&"phase", boss_phase)
	blackboard1.set_var(&"manager_path", get_path())
	blackboard2.set_var(&"manager_path", get_path())
	blackboard1.set_var(&"current_waypoint", starting_waypoint1)
	blackboard2.set_var(&"current_waypoint", starting_waypoint2)
	blackboard1.set_var(&"other_dancer", dancer2)
	blackboard2.set_var(&"other_dancer", dancer1)
	blackboard1.set_var(&"other_dancer_next_waypoint", dancer2.behavior_tree.blackboard.get_var(&"next_waypoint"))
	blackboard2.set_var(&"other_dancer_next_waypoint", dancer1.behavior_tree.blackboard.get_var(&"next_waypoint"))
	blackboard1.set_var(&"spin_slashes_path", spin_slashes.get_path())
	blackboard2.set_var(&"spin_slashes_path", spin_slashes.get_path())
	blackboard1.set_var(&"spinner", spinner)
	blackboard2.set_var(&"spinner", spinner)
	blackboard1.set_var(&"spinner_path", spinner.get_path())
	blackboard2.set_var(&"spinner_path", spinner.get_path())
	blackboard1.set_var(&"spin_target", spin_target1)
	blackboard2.set_var(&"spin_target", spin_target2)
	blackboard1.set_var(&"self", dancer1)
	blackboard2.set_var(&"self", dancer2)
	blackboard1.set_var(&"direction_light", dancer1.get_node("Direction"))
	blackboard2.set_var(&"direction_light", dancer2.get_node("Direction"))
	blackboard1.set_var(&"direction_light", dancer1.get_node("Direction"))
	blackboard1.set_var(&"teleport_point", teleport_point)
	blackboard2.set_var(&"teleport_point", teleport_point)

func increment_phase() -> void:
	boss_phase += 1

func request_next_waypoint(requesting_dancer: CogworkDancer) -> Node:
	if requesting_dancer == dancer1:
		var current_waypoint: Node3D = blackboard1.get_var(&"current_waypoint")
		_waypoint1 = _waypoints.pick_random()
		while _waypoint1 == _waypoint2 or _waypoint1 == current_waypoint:
			_waypoint1 = _waypoints.pick_random()
		return _waypoint1
	elif requesting_dancer == dancer2:
		var current_waypoint: Node3D = blackboard2.get_var(&"current_waypoint")
		_waypoint2 = _waypoints.pick_random()
		while _waypoint2 == _waypoint1 or _waypoint2 == current_waypoint:
			_waypoint2 = _waypoints.pick_random()
		return _waypoint2
	return _waypoints.pick_random()

func set_ready_for_special_attack(dancer: CogworkDancer, dancer_ready: bool) -> void:
	if dancer == dancer1:
		blackboard2.set_var(&"other_dancer_ready_for_special_attack", dancer_ready)
	elif dancer == dancer2:
		blackboard1.set_var(&"other_dancer_ready_for_special_attack", dancer_ready)

func _reset_special_attack_time() -> void:
	var current_music: AudioStream = AudioManager.current_music_player.stream
	if is_instance_valid(current_music):
		if AudioManager.current_music_player.get_playback_position() < current_music.get_length() - 2:
			_special_attack_timer = 0
		_special_attack_delay = randf_range(min_special_attack_delay, max_special_attack_delay)

func _set_up_spin() -> void:
	blackboard1.set_var(&"should_spin", true)
	blackboard2.set_var(&"should_spin", true)

func _set_up_teleport() -> void:
	blackboard1.set_var(&"should_teleport", true)
	blackboard2.set_var(&"should_teleport", true)

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

func _on_music_loop() -> void:
	_reset_special_attack_time()
