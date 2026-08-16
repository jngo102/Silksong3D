extends Node

func _ready() -> void:
	set_process_mode(PROCESS_MODE_ALWAYS)

## Stop time, optionally for a specified duration
func stop_time(do_pause: bool = true, duration: float = 0) -> void:
	get_tree().set_pause.call_deferred(do_pause)
	if do_pause and duration > 0:
		await get_tree().create_timer(duration).timeout
		get_tree().paused = false
