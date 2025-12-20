class_name PlayerHSM extends LimboHSM

const ATTACK_EVENT: StringName = "attack"
const BIND_EVENT: StringName = "bind"
const DAMAGE_EVENT: StringName = "damage"
const DASH_EVENT: StringName = "dash"
const FALL_EVENT: StringName = "fall"
const HIT_EVENT: StringName = "hit"
const JUMP_EVENT: StringName = "jump"
const LAND_EVENT: StringName = "land"
const MOVE_EVENT: StringName = "move"
const STOP_EVENT: StringName = "stop"

@onready var _player: Player = get_owner()
@onready var air_dash_state: PlayerAirDashState = $AirDashState
@onready var attack_choice_state: PlayerAttackChoiceState = $AttackChoiceState
@onready var big_recoil_state: PlayerRecoilState = $BigRecoilState
@onready var down_spike_state: PlayerDownSpikeState = $DownSpikeState
@onready var down_spike_bounce_state: PlayerDownSpikeBounceState = $DownSpikeBounceState
@onready var fall_state: PlayerFallState = $FallState
@onready var float_state: PlayerFloatState = $FloatState
@onready var idle_state: PlayerIdleState = $IdleState
@onready var jump_state: PlayerJumpState = $JumpState
@onready var land_state: PlayerLandState = $LandState
@onready var normal_recoil_state: PlayerRecoilState = $NormalRecoilState
@onready var slash_state: PlayerSlashState = $SlashState
@onready var sprint_state: PlayerSprintState = $SprintState
@onready var sprint_jump_state: PlayerSprintJumpState = $SprintJumpState
@onready var walk_state: PlayerWalkState = $WalkState

func _ready() -> void:
	await _player.ready
	_assign_events()
	_add_transitions()
	_reset()

func _assign_events() -> void:
	_player.health.took_damage.connect(func(damager: Damager):
		if damager.damage_amount == 1:
			change_active_state(normal_recoil_state)
		elif damager.damage_amount > 1:
			change_active_state(big_recoil_state))

func _add_transitions() -> void:
	add_transition(ANYSTATE, air_dash_state, DASH_EVENT)
	add_transition(ANYSTATE, attack_choice_state, ATTACK_EVENT)

	add_transition(attack_choice_state, down_spike_state, DASH_EVENT)
	add_transition(attack_choice_state, slash_state, ATTACK_EVENT)
	
	add_transition(air_dash_state, sprint_state, MOVE_EVENT)
	add_transition(air_dash_state, fall_state, EVENT_FINISHED)
	
	add_transition(big_recoil_state, idle_state, EVENT_FINISHED)
	
	add_transition(down_spike_state, down_spike_bounce_state, HIT_EVENT)
	add_transition(down_spike_state, fall_state, EVENT_FINISHED)
	add_transition(down_spike_state, land_state, LAND_EVENT)
	
	add_transition(down_spike_bounce_state, fall_state, EVENT_FINISHED)
	add_transition(down_spike_bounce_state, float_state, JUMP_EVENT)
	add_transition(down_spike_bounce_state, land_state, LAND_EVENT)
	
	add_transition(jump_state, fall_state, FALL_EVENT)
	add_transition(jump_state, float_state, JUMP_EVENT)
	
	add_transition(fall_state, float_state, JUMP_EVENT)
	add_transition(fall_state, land_state, LAND_EVENT)
	
	add_transition(float_state, fall_state, FALL_EVENT)
	add_transition(float_state, land_state, LAND_EVENT)
	
	add_transition(idle_state, fall_state, FALL_EVENT)
	add_transition(idle_state, jump_state, JUMP_EVENT)
	add_transition(idle_state, walk_state, MOVE_EVENT)
	
	add_transition(land_state, idle_state, STOP_EVENT)
	add_transition(land_state, sprint_state, DASH_EVENT)
	add_transition(land_state, walk_state, MOVE_EVENT)
	
	add_transition(normal_recoil_state, idle_state, EVENT_FINISHED)

	add_transition(slash_state, idle_state, EVENT_FINISHED)

	add_transition(sprint_state, idle_state, STOP_EVENT)
	add_transition(sprint_state, sprint_jump_state, JUMP_EVENT)
	
	add_transition(sprint_jump_state, fall_state, FALL_EVENT)
	add_transition(sprint_jump_state, float_state, JUMP_EVENT)
	
	add_transition(walk_state, fall_state, FALL_EVENT)
	add_transition(walk_state, idle_state, STOP_EVENT)
	add_transition(walk_state, jump_state, JUMP_EVENT)

func _reset() -> void:
	initial_state = idle_state
	initialize(_player)
	set_active(true)

func _on_active_state_changed(current: LimboState, previous: LimboState) -> void:
	print(previous, " to ", current)
