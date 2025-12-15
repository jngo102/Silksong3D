@tool
extends BTAction

@export var output_bpm_var := &"bpm"

func _generate_name() -> String:
	return "Get Current Music BPM"

func _tick(_delta: float) -> Status:
	blackboard.set_var(output_bpm_var, AudioManager.current_track.bpm)
	return SUCCESS
