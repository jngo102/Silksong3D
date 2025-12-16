class_name Player extends Actor

const PARAMS: String = "parameters"
const CONDS: String = "%s/conditions" % PARAMS
const WALK_BLEND: String = "%s/Walk/blend_position" % PARAMS

@export var jump_height: float = 7
@export var walk_speed: float = 24
@export var sprint_speed: float = 48
@export var down_spike_speed: float = 90
@export var down_spike_bounce_spin_speed: float = 30

@export var _camera_controller: CameraController

@onready var _model: Node3D = $Model
@onready var _armature: Node3D = _model.get_node_or_null("Armature")
@onready var _skeleton = _armature.get_node_or_null("Skeleton3D")
@onready var _head: MeshInstance3D = _skeleton.get_node_or_null("Head")
@onready var _needle: Needle = _skeleton.get_node_or_null("NeedleAttach/Needle")
@onready var _cloak_anim: AnimationPlayer = _skeleton.get_node_or_null("CloakAttach/CloakAnimator")
@onready var _model_tree: AnimationTree = _model.get_node_or_null("AnimationPlayer/AnimationTree")

var moving_forward: bool:
	get:
		return velocity.rotated(Vector3.UP, global_rotation.y).z < 0

var walking: bool:
	get:
		return is_equal_approx(Vector2(velocity.x, velocity.z).length(), walk_speed)

var should_sprint: bool:
	get:
		return Input.is_action_pressed(&"Sprint")

var sprinting: bool:
	get:
		return is_equal_approx(velocity.length(), sprint_speed)

var floating: bool = false

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

var current_move_speed: float = walk_speed
var was_on_floor: bool
var already_jumped: bool
var should_down_spike: bool:
	set(value):
		should_down_spike = value
		if value:
			velocity = Vector3.ZERO

var down_spiking: bool:
	set(value):
		down_spiking = value
		if value:
			should_down_spike = false
			velocity = -_camera_controller.camera.global_basis.z.normalized() * down_spike_speed
			_armature.look_at(global_position - velocity)

var down_spike_bouncing: bool:
	set(value):
		down_spike_bouncing = value
		if value:
			await get_tree().create_timer(0.35, false).timeout
			down_spike_bouncing = false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_camera_controller.target = _head

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_look_mouse(event)
	elif event.is_action_pressed(&"Attack"):
		_check_attack()
	elif event.is_action_pressed(&"Target"):
		_try_target()

func _process(delta: float) -> void:
	if not should_down_spike and not down_spiking and not down_spike_bouncing:
		var move_vector: Vector2 = Input.get_vector(&"ui_left", &"ui_right", &"ui_up", &"ui_down").normalized() * current_move_speed
		velocity = Vector3(move_vector.x, velocity.y, move_vector.y).rotated(Vector3.UP, _camera_controller.global_rotation.y)
	_apply_gravity(delta)
	_check_walk(delta)
	_check_sprint(delta)
	_look_joystick(delta)
	_check_jump()
	_check_float()
	_check_landed()
	_check_down_spike_bounce(delta)
	was_on_floor = is_on_floor()
	super._process(delta)

func _check_walk(delta: float) -> void:
	if sprinting:
		return
	var current_move_blend: Vector2 = _model_tree.get(WALK_BLEND)
	_model_tree.set(WALK_BLEND, current_move_blend.move_toward(Vector2(-velocity.x, -velocity.z).rotated(global_rotation.y).normalized(), delta * 8))
	global_rotation.y = lerp_angle(global_rotation.y, _camera_controller.global_rotation.y + PI, delta * 4)

func _check_sprint(delta: float) -> void:
	if is_on_floor():
		if should_sprint and is_equal_approx(current_move_speed, walk_speed):
			current_move_speed = sprint_speed
		elif sprinting and not Input.is_action_pressed(&"Sprint"):
			current_move_speed = walk_speed

	if sprinting and velocity.length() > 0:
		global_rotation.y = lerp_angle(global_rotation.y, atan2(velocity.z, -velocity.x) - PI / 2, delta * 16)

func _look_mouse(event: InputEventMouseMotion) -> void:
	_camera_controller.rotation.y -= event.relative.x * 0.01
	_camera_controller.add_pitch(-event.relative.y * 0.01)

func _look_joystick(delta: float) -> void:
	var look_vector: Vector2 = Input.get_vector(&"ui_look_left", &"ui_look_right", &"ui_look_down", &"ui_look_up")
	_camera_controller.rotation.y -= look_vector.x * delta
	_camera_controller.add_pitch(-look_vector.y * delta)

func _check_jump() -> void:
	if Input.is_action_just_pressed(&"Jump"):
		if not already_jumped:
			_jump()
		else:
			_float()
	elif Input.is_action_just_released(&"Jump") and velocity.y > 0:
		_stop_jump()

func _jump() -> void:
	if is_on_floor():
		velocity.y = sqrt(jump_height * gravity * jump_height * 0.1)
		already_jumped = true

func _stop_jump() -> void:
	velocity.y /= 5

func _check_float() -> void:
	if should_down_spike or down_spiking:
		return
	if not is_on_floor() and already_jumped and Input.is_action_just_pressed(&"Jump"):
		_float()
	elif floating and Input.is_action_just_released(&"Jump"):
		_stop_float()

func _float() -> void:
	_cloak_anim.play("Puff Out")
	floating = true
	_down_spike_reset()

func _stop_float() -> void:
	_cloak_anim.play("Unpuff")
	floating = false

func _apply_gravity(delta: float) -> void:
	if not is_on_floor() and not down_spiking:
		if not floating:
			velocity.y -= gravity * delta * 0.1
		else:
			velocity.y = max(velocity.y - gravity * delta * 0.1, -2)

func _check_landed() -> void:
	if is_on_floor() and not was_on_floor:
		_land()

func _land() -> void:
	already_jumped = false
	_stop_float()
	_down_spike_reset()

func _check_attack() -> void:
	if not is_on_floor() and _camera_controller.camera.global_rotation_degrees.x < -45:
		_start_down_spike()
	else:
		_slash()

func _slash() -> void:
	floating = false
	_down_spike_reset()
	_needle.slash()

func _start_down_spike() -> void:
	_down_spike_reset()
	should_down_spike = true
	_needle.down_spike()

func _down_spike() -> void:
	down_spiking = true
	await get_tree().create_timer(0.125, false).timeout
	if down_spiking:
		_down_spike_reset()

func _down_spike_bounce() -> void:
	down_spiking = false
	var direction: Vector3 = -_camera_controller.camera.global_basis.z
	_armature.rotation = Vector3.ZERO
	velocity.y = down_spike_speed
	down_spike_bouncing = true

func _check_down_spike_bounce(delta: float) -> void:
	if down_spike_bouncing:
		_armature.rotate_x(down_spike_bounce_spin_speed * delta)

func _down_spike_reset() -> void:
	should_down_spike = false
	down_spiking = false
	_armature.rotation = Vector3.ZERO
	_needle.down_spike_reset()

func _try_target() -> void:
	pass

func _on_animation_tree_animation_started(anim_name: StringName) -> void:
	print(anim_name)

func _on_needle_down_spiked() -> void:
	_down_spike_bounce()

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"Down Spike Antic":
			_down_spike()
