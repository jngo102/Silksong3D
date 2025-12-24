class_name Player extends GroundedActor

@export var jump_height: float = 7
@export var walk_speed: float = 24
@export var sprint_speed: float = 48
@export var down_spike_speed: float = 90
@export var down_spike_bounce_spin_speed: float = 30

@export var camera_controller: CameraController

@onready var spool_manager: SpoolManager = $SpoolManager
@onready var _model: Node3D = $Model
@onready var armature: Node3D = _model.get_node_or_null("Armature")
@onready var _skeleton = armature.get_node_or_null("Skeleton3D")
@onready var _head: MeshInstance3D = _skeleton.get_node_or_null("Head")
@onready var needle: Needle = _skeleton.get_node_or_null("NeedleAttach/Needle")
@onready var _cloak_anim: AnimationPlayer = _skeleton.get_node_or_null("CloakAttach/CloakAnimator")
@onready var model_animator: AnimationPlayer = _model.get_node_or_null("AnimationPlayer")
@onready var walk_blend_tree: AnimationTree = model_animator.get_node_or_null("WalkBlend")

var moving_forward: bool:
	get:
		return velocity.rotated(Vector3.UP, global_rotation.y).z < 0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera_controller.target = _head

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_look_mouse(event)

func _process(delta: float) -> void:
	_look_joystick(delta)
	super._process(delta)

func face_direction(direction: Vector3) -> void:
	direction = direction.rotated(Vector3.UP, camera_controller.global_rotation.y - PI / 2)
	super.face_direction(direction)

func turn_to_camera(delta: float, immediate: bool = false) -> void:
	global_rotation.y = lerp_angle(global_rotation.y, camera_controller.global_rotation.y,  1 if immediate else delta * 4)

func _look_mouse(event: InputEventMouseMotion) -> void:
	var look_x: float = -event.relative.x * get_process_delta_time() * SaveManager.settings.look_sensitivity_mouse
	if SaveManager.settings.invert_mouse_x:
		look_x = -look_x
	camera_controller.rotation.y += look_x
	
	var look_y: float = -event.relative.y * get_process_delta_time() * SaveManager.settings.look_sensitivity_mouse
	if SaveManager.settings.invert_mouse_x:
		look_y = -look_y
	camera_controller.add_pitch(look_y)

func _look_joystick(delta: float) -> void:
	var look_vector: Vector2 = Input.get_vector(&"ui_look_left", &"ui_look_right", &"ui_look_down", &"ui_look_up")
	var look_x: float = -look_vector.x * get_process_delta_time() * SaveManager.settings.look_sensitivity_joystick * 4
	if SaveManager.settings.invert_joystick_x:
		look_x = -look_x
	camera_controller.rotation.y += look_x
	
	var look_y: float = look_vector.y * get_process_delta_time() * SaveManager.settings.look_sensitivity_joystick * 4
	if SaveManager.settings.invert_joystick_y:
		look_y = -look_y
	camera_controller.add_pitch(look_y)
