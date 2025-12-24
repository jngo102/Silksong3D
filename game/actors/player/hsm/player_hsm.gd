class_name PlayerHSM extends LimboHSM

const ATTACK_EVENT: StringName = "attack"
const BIG_DAMAGE_EVENT: StringName = "big damage"
const BIND_EVENT: StringName = "bind"
const DAMAGE_EVENT: StringName = "damage"
const DASH_EVENT: StringName = "dash"
const FALL_EVENT: StringName = "fall"
const HIT_EVENT: StringName = "hit"
const JUMP_EVENT: StringName = "jump"
const LAND_EVENT: StringName = "land"
const MOVE_EVENT: StringName = "move"
const MULTI_HIT_EVENT: StringName = "multi hit"
const SKILL_EVENT: StringName = "skill"
const STOP_EVENT: StringName = "stop"

@onready var _player: Player = get_owner()
@onready var air_dash_state: PlayerAirDashState = $AirDashState
@onready var attack_choice_state: PlayerAttackChoiceState = $AttackChoiceState
@onready var big_recoil_state: PlayerRecoilState = $BigRecoilState
@onready var bind_state: PlayerBindState = $BindState
@onready var down_spike_state: PlayerDownSpikeState = $DownSpikeState
@onready var down_spike_bounce_state: PlayerDownSpikeBounceState = $DownSpikeBounceState
@onready var fall_state: PlayerFallState = $FallState
@onready var float_state: PlayerFloatState = $FloatState
@onready var idle_state: PlayerIdleState = $IdleState
@onready var jump_state: PlayerJumpState = $JumpState
@onready var land_state: PlayerLandState = $LandState
@onready var multi_hit_state: PlayerMultiHitState = $MultiHitState
@onready var normal_recoil_state: PlayerRecoilState = $NormalRecoilState
@onready var slash_state: PlayerSlashState = $SlashState
@onready var sprint_state: PlayerSprintState = $SprintState
@onready var sprint_jump_state: PlayerSprintJumpState = $SprintJumpState
@onready var sprint_stab_state: PlayerSprintStabState = $SprintStabState
@onready var thread_storm_state: PlayerThreadStormState = $ThreadStormState
@onready var walk_state: PlayerWalkState = $WalkState

func _ready() -> void:
	await _player.ready
	_add_transitions()
	_reset()
	_set_up_events()

func _add_transitions() -> void:
	add_transition(ANYSTATE, attack_choice_state, ATTACK_EVENT)
	add_transition(ANYSTATE, thread_storm_state, SKILL_EVENT)
	add_transition(ANYSTATE, big_recoil_state, BIG_DAMAGE_EVENT)
	add_transition(ANYSTATE, bind_state, BIND_EVENT)
	add_transition(ANYSTATE, idle_state, EVENT_FINISHED)
	add_transition(ANYSTATE, multi_hit_state, MULTI_HIT_EVENT)
	add_transition(ANYSTATE, normal_recoil_state, DAMAGE_EVENT)

	add_transition(attack_choice_state, down_spike_state, FALL_EVENT)
	add_transition(attack_choice_state, slash_state, ATTACK_EVENT)
	add_transition(attack_choice_state, sprint_stab_state, DASH_EVENT)
	
	air_dash_state.set_guard(air_dash_state.can_enter)
	
	big_recoil_state.set_guard(big_recoil_state.can_enter)
	bind_state.set_guard(bind_state.can_enter)
	
	add_transition(down_spike_state, down_spike_bounce_state, HIT_EVENT)
	add_transition(down_spike_state, land_state, LAND_EVENT)
	
	add_transition(down_spike_bounce_state, air_dash_state, DASH_EVENT)
	add_transition(down_spike_bounce_state, float_state, JUMP_EVENT)
	add_transition(down_spike_bounce_state, land_state, LAND_EVENT)
	
	add_transition(jump_state, air_dash_state, DASH_EVENT)
	add_transition(jump_state, fall_state, FALL_EVENT)
	add_transition(jump_state, float_state, JUMP_EVENT)
	
	add_transition(fall_state, air_dash_state, DASH_EVENT)
	add_transition(fall_state, float_state, JUMP_EVENT)
	add_transition(fall_state, land_state, LAND_EVENT)
	
	add_transition(float_state, air_dash_state, DASH_EVENT)
	add_transition(float_state, fall_state, FALL_EVENT)
	add_transition(float_state, land_state, LAND_EVENT)
	
	add_transition(idle_state, fall_state, FALL_EVENT)
	add_transition(idle_state, jump_state, JUMP_EVENT)
	add_transition(idle_state, walk_state, MOVE_EVENT)
	
	add_transition(land_state, idle_state, STOP_EVENT)
	add_transition(land_state, sprint_state, DASH_EVENT)
	add_transition(land_state, walk_state, MOVE_EVENT)
	
	add_transition(multi_hit_state, idle_state, EVENT_FINISHED)
	
	normal_recoil_state.set_guard(normal_recoil_state.can_enter)

	add_transition(sprint_state, idle_state, STOP_EVENT)
	add_transition(sprint_state, sprint_jump_state, JUMP_EVENT)
	
	add_transition(sprint_jump_state, fall_state, FALL_EVENT)
	add_transition(sprint_jump_state, float_state, JUMP_EVENT)
	
	add_transition(sprint_stab_state, fall_state, EVENT_FINISHED)
	add_transition(sprint_stab_state, down_spike_bounce_state, HIT_EVENT)
	
	thread_storm_state.set_guard(thread_storm_state.can_enter)
	
	add_transition(walk_state, sprint_state, DASH_EVENT)
	add_transition(walk_state, fall_state, FALL_EVENT)
	add_transition(walk_state, idle_state, STOP_EVENT)
	add_transition(walk_state, jump_state, JUMP_EVENT)

func _reset() -> void:
	initial_state = idle_state
	initialize(_player)
	set_active(true)

func _set_up_events() -> void:
	_player.landed.connect(_on_player_land)

func _on_player_land() -> void:
	air_dash_state.reset_state()

func _on_active_state_changed(current: LimboState, previous: LimboState) -> void:
	if OS.is_debug_build():
		print(previous, " to ", current)
