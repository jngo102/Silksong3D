class_name Player extends Actor

const PARAMS: String = "parameters"
const CONDS: String = "%s/conditions" % PARAMS
const WALK_BLEND: String = "%s/Walk/blend_position" % PARAMS

@export var jump_height: float = 4
@export var walk_speed: float = 10
@export var sprint_speed: float = 25
@export var down_spike_speed: float = 60
@export var _cam_pivot: CameraController

@onready var _armature = $Armature
@onready var _skeleton = _armature.get_node_or_null("Skeleton3D")
@onready var _needle: Needle = _skeleton.get_node_or_null("NeedleAttach/Needle")
@onready var _cloak_anim: AnimationPlayer = _skeleton.get_node_or_null("CloakAttach/CloakAnimator")

var moving_forward: bool:
	get:
		return velocity.rotated(Vector3.UP, global_rotation.y).z < 0

var walking: bool:
	get:
		return is_equal_approx(Vector2(velocity.x, velocity.z).length(), walk_speed)

var should_sprint: bool:
	get:
		return moving_forward and Input.is_action_pressed("Sprint")

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
			velocity = (-_cam_pivot.camera.global_basis.z).normalized() * down_spike_speed
			_armature.look_at(global_position + velocity)

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_look_mouse(event)
	elif event.is_action_pressed("Attack"):
		_check_attack()

func _process(delta: float) -> void:
	if not should_down_spike and not down_spiking:
		var move_vector: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized() * current_move_speed
		velocity = Vector3(-move_vector.x, velocity.y, -move_vector.y).rotated(Vector3.UP, _cam_pivot.global_rotation.y)
	_apply_gravity(delta)
	_check_walk(delta)
	_check_sprint(delta)
	_look_joystick(delta)
	_check_jump()
	_check_float()
	_check_landed()
	_check_down_spike_bounce(delta)
	was_on_floor = is_on_floor()
	move_and_slide()

func _check_walk(delta: float) -> void:
	if sprinting:
		return
	var current_move_blend: Vector2 = _anim_tree.get(WALK_BLEND)
	_anim_tree.set(WALK_BLEND, current_move_blend.move_toward(Vector2(velocity.x, velocity.z).rotated(global_rotation.y).normalized(), delta * 5))
	global_rotation.y = lerp_angle(global_rotation.y, _cam_pivot.global_rotation.y + PI, delta * 4)

func _check_sprint(delta: float) -> void:
	if is_on_floor():
		if should_sprint and is_equal_approx(current_move_speed, walk_speed):
			current_move_speed = sprint_speed
		elif sprinting and not Input.is_action_pressed("Sprint"):
			current_move_speed = walk_speed

	if sprinting and velocity.length() > 0:
		global_rotation.y = lerp_angle(global_rotation.y, atan2(-velocity.z, velocity.x) - PI / 2, delta * 16)

func _look_mouse(event: InputEventMouseMotion) -> void:
	_cam_pivot.rotation.y -= event.relative.x * 0.01
	_cam_pivot.add_pitch(event.relative.y * 0.01)

func _look_joystick(delta: float) -> void:
	var look_vector: Vector2 = Input.get_vector("Look Left", "Look Right", "Look Down", "Look Up")
	_cam_pivot.rotation.y -= look_vector.x * 0.015
	_cam_pivot.add_pitch(-look_vector.y * 0.01)

func _check_jump() -> void:
	if Input.is_action_just_pressed("Jump"):
		if not already_jumped:
			_jump()
		else:
			_float()
	elif Input.is_action_just_released("Jump") and velocity.y > 0:
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
	if not is_on_floor() and already_jumped and Input.is_action_just_pressed("Jump"):
		_float()
	elif floating and Input.is_action_just_released("Jump"):
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
	if not is_on_floor() and _cam_pivot.camera.global_rotation_degrees.x < -45:
		_start_down_spike()
	else:
		_slash()

func _slash() -> void:
	_down_spike_reset()
	_needle.slash()

func _start_down_spike() -> void:
	_down_spike_reset()
	should_down_spike = true
	_needle.down_spike()

func _down_spike() -> void:
	down_spiking = true

func _down_spike_bounce() -> void:
	down_spiking = false
	var direction: Vector3 = -_cam_pivot.camera.global_basis.z
	_armature.rotation = Vector3.ZERO
	velocity.y = down_spike_speed

func _check_down_spike_bounce(delta: float) -> void:
	if _needle.down_spike_hit:
		_armature.rotate_x(-10 * delta)

func _down_spike_reset() -> void:
	should_down_spike = false
	down_spiking = false
	_armature.rotation = Vector3.ZERO
	_needle.down_spike_reset()

func _on_animation_tree_animation_started(anim_name: StringName) -> void:
	print(anim_name)

func _on_needle_down_spiked() -> void:
	_down_spike_bounce()

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"Down Spike Antic":
			_down_spike()
