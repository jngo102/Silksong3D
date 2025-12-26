class_name Player extends GroundedActor

@export var jump_height: float = 7
@export var walk_speed: float = 24
@export var sprint_speed: float = 48
@export var down_spike_speed: float = 90
@export var down_spike_bounce_spin_speed: float = 30

@export var camera_controller: CameraController
@export var change_target_distance_mouse: float = 0.3
@export var change_target_distance_joystick: float = 0.2

@onready var spool_manager: SpoolManager = $SpoolManager
@onready var _model: Node3D = $Model
@onready var armature: Node3D = _model.get_node_or_null("Armature")
@onready var _skeleton = armature.get_node_or_null("Skeleton3D")
@onready var _head: MeshInstance3D = _skeleton.get_node_or_null("Head")
@onready var needle: Needle = _skeleton.get_node_or_null("NeedleAttach/Needle")
@onready var _cloak_anim: AnimationPlayer = _skeleton.get_node_or_null("CloakAttach/CloakAnimator")
@onready var model_animator: AnimationPlayer = _model.get_node_or_null("AnimationPlayer")
@onready var walk_blend_tree: AnimationTree = model_animator.get_node_or_null("WalkBlend")
@onready var targeter: Marker3D = _head.get_node_or_null("Targeter")
@onready var _targeter_offset: Vector3 = targeter.position

var moving_forward: bool:
	get:
		return velocity.rotated(Vector3.UP, global_rotation.y).z < 0

var target: Node3D:
	set(value):
		target = value
		if is_instance_valid(value):
			camera_controller.add_target(targeter)
		else:
			camera_controller.remove_target(targeter)

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_init_camera_targets()

func _init_camera_targets() -> void:
	camera_controller.add_target(self)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var look_vector: Vector2 = -event.relative * get_process_delta_time() * SaveManager.settings.look_sensitivity_mouse
		if SaveManager.settings.invert_mouse_x:
			look_vector.x = -look_vector.x
		if SaveManager.settings.invert_mouse_y:
			look_vector.y = -look_vector.y
		if not is_instance_valid(target):
			_look_mouse(look_vector)
		else:
			_check_change_target(event.relative, event.position, change_target_distance_mouse)
	elif event.is_action_pressed(&"Target"):
		if not is_instance_valid(target):
			_choose_target()
		else:
			_clear_target()

func _process(delta: float) -> void:
	_look_joystick(delta)
	_check_look_at_target(delta)
	super._process(delta)

func face_direction(direction: Vector3) -> void:
	direction = direction.rotated(Vector3.UP, camera_controller.global_rotation.y - PI / 2)
	super.face_direction(direction)

func turn_to_camera(delta: float, immediate: bool = false) -> void:
	global_rotation.y = lerp_angle(global_rotation.y, camera_controller.global_rotation.y,  1 if immediate else delta * 4)

func _look_mouse(look_vector: Vector2) -> void:
	camera_controller.add_yaw(look_vector.x)
	camera_controller.add_pitch(look_vector.y)

func _look_joystick(delta: float) -> void:
	var look_vector: Vector2 = Input.get_vector(&"ui_look_left", &"ui_look_right", &"ui_look_up", &"ui_look_down")
	var look: Vector2 = -look_vector * get_process_delta_time() * SaveManager.settings.look_sensitivity_joystick * 4
	if SaveManager.settings.invert_joystick_x:
		look.x = -look.x
	if SaveManager.settings.invert_joystick_y:
		look.y = -look.y
	
	if not is_instance_valid(target):
		camera_controller.add_yaw(look.x)
		camera_controller.add_pitch(look.y)
	else:
		_check_change_target(look_vector, Vector2.ZERO, change_target_distance_joystick)

func _check_look_at_target(delta: float) -> void:
	if is_instance_valid(target):
		var target_position: Vector3 = target.global_position
		var distance: float = targeter.global_position.distance_to(target_position)
		if distance > 128:
			_clear_target()
			return
		if target is Enemy:
			var point: VisibleOnScreenNotifier3D = target.target_point
			if not point.visible:
				_clear_target()
				return
			target_position = point.global_position
		targeter.global_position = targeter.global_position.lerp(target_position, delta * 8)
	else:
		targeter.position = targeter.position.lerp(_targeter_offset, delta * 8)

func _choose_target() -> void:
	var new_target: Node3D
	var shortest_distance: float = 64
	for candidate in get_tree().get_nodes_in_group(&"Targetable"):
		if candidate is Node3D:
			var direction: Vector3 = -targeter.global_basis.z
			var distance: float = targeter.global_position.cross(direction).length() / direction.length()
			if distance < shortest_distance:
				new_target = candidate
	_select_target(new_target)

func _select_target(new_target: Node3D) -> void:
	if is_instance_valid(new_target):
		_clear_target()
		target = new_target

func _check_change_target(look_vector: Vector2, event_position: Vector2, threshold: float) -> void:
	if look_vector.length() * get_process_delta_time() > threshold:
		var shortest_distance: float = INF
		var next_target: Node3D
		var candidates: Array[Node] = get_tree().get_nodes_in_group(&"Targetable").filter(func(node): return node != target)
		for candidate in candidates:
			if candidate is Node3D:
				var target_screen_position: Vector2 = get_viewport().get_camera_3d().unproject_position(target.global_position)
				var candidate_screen_position: Vector2 = get_viewport().get_camera_3d().unproject_position(candidate.global_position)
				var target_to_candidate_angle: float = (candidate_screen_position - target_screen_position).angle()
				var mouse_to_candidate_vector: Vector2 = event_position.direction_to(candidate_screen_position)
				var look_angle: float = atan2(look_vector.y, look_vector.x)
				if abs(target_to_candidate_angle - look_angle) > PI / 2:
					continue
				var distance: float = abs(mouse_to_candidate_vector.cross(look_vector)) / look_vector.length()
				if distance < shortest_distance:
					shortest_distance = distance
					next_target = candidate
		_select_target(next_target)

func _clear_target() -> void:
	target = null
