## Manages game audio and music
extends Node3D

## The prefab to instantiate when playing a one shot clip
@export var audio_player_prefab: PackedScene

## Parent of all spawned generic audio players
@onready var audio_players: Node3D = $AudioPlayers
## Parent of all spawned music players
@onready var music_players: Node = $MusicPlayers
## The audio stream player of the current music track, fades out to next music player
@onready var current_music_player: AudioStreamPlayer = music_players.get_node("CurrentMusicPlayer")
## The audio stream player of the next music track, fades in from current music player
@onready var next_music_player: AudioStreamPlayer = music_players.get_node("NextMusicPlayer")

## Emitted when the music reaches a downbeat
signal downbeat

## The currently playing music track
var current_track: MusicTrack:
	set(value):
		current_track = value
		current_music_player.stream = value.music_clip if (value != null) else null

## The number of beats into the current track in the previous frame
var previous_beats_played: int
## The number of beats into the current track
var beats_played: int
## The currently running tween for adjusting volume fade between music tracks
var volume_tween: Tween

## The volume in decibels at which audio is not perceived
var _audio_off_db: float = ProjectSettings.get_setting("audio/buses/channel_disable_threshold_db")

## The duration of a single beat
var beat_length: float:
	get:
		if current_track == null:
			return -1
		return 60.0 / current_track.bpm

## Time to the next beat of the current song
var time_to_next_beat: float:
	get:
		if current_track == null:
			return INF
		var sec: float = current_music_player.get_playback_position()
		return beat_length - fposmod(sec, beat_length)
	
## Music volume combined with master volume
var music_volume: float:
	get:
		return remap(SaveManager.settings.master_volume * SaveManager.settings.music_volume, 0.0, 1.0, _audio_off_db, 0)
	
## SFX volume combined with master volume
var sfx_volume: float:
	get:
		return remap(SaveManager.settings.master_volume * SaveManager.settings.sfx_volume, 0.0, 1.0, _audio_off_db, 0)

func _ready() -> void:
	update_music_volume()

func _process(_delta: float) -> void:
	check_downbeat()

## Check whether to emit the downbeat signal
func check_downbeat() -> void:
	if current_track == null:
		return
	var sec_per_beat: float = 60.0 / current_track.bpm
	var sec: float = current_music_player.get_playback_position()
	previous_beats_played = beats_played
	beats_played = floor(sec / sec_per_beat)
	if previous_beats_played != beats_played:
		downbeat.emit()
	
## Play a one shot audio clip
func play_clip(clip: AudioStream, play_position := Vector3.ZERO, pitch_min: float = 1, pitch_max: float = 1, volume_scale: float = 1, range: float = 24) -> void:
	var audio_player: AudioPlayer = audio_player_prefab.instantiate()
	audio_players.add_child(audio_player)
	audio_player.global_position = play_position
	audio_player.volume_db = remap(volume_scale * SaveManager.settings.master_volume * SaveManager.settings.music_volume, 0.0, 1.0, _audio_off_db, 0)
	audio_player.pitch_scale = randf_range(pitch_min, pitch_max)
	audio_player.unit_size = range
	audio_player.finished.connect(func(): audio_player.queue_free())
	audio_player.stream = clip
	audio_player.play()

## Play a music track, fading out from the current track into the new track
func play_music(track: MusicTrack, fade_time: float = 2, immediate: bool = false) -> void:
	# Immediately play music if nothing is currently playing (or if immediate specified)
	current_track = track
	if not current_music_player.stream or immediate:
		current_music_player.set_stream(track.music_clip)
		current_music_player.play()
		return
	# Don't fade in and out of the same music track
	elif current_music_player.stream and track.music_clip.resource_path == current_music_player.stream.resource_path:
		return
	next_music_player.set_stream(track.music_clip)
	if volume_tween and volume_tween.is_running():
		volume_tween.kill()
	volume_tween = create_tween()
	volume_tween.finished.connect(_on_volume_tween_finished)
	next_music_player.play(current_music_player.get_playback_position())
	volume_tween.tween_property(current_music_player, "volume_db", _audio_off_db, fade_time) \
		.from(music_volume) \
		.set_trans(Tween.TRANS_EXPO) \
		.set_ease(Tween.EASE_IN)
	volume_tween.parallel().tween_property(next_music_player, "volume_db", music_volume, fade_time) \
		.from(_audio_off_db) \
		.set_trans(Tween.TRANS_EXPO) \
		.set_ease(Tween.EASE_OUT)

## Stop the currently playing music
func stop_music() -> void:
	current_music_player.stop()
	current_music_player.stream = null
	next_music_player.stop()
	next_music_player.stream = null
	current_track = null

## Update the current music volume
func update_music_volume() -> void:
	current_music_player.volume_db = music_volume

## Callback for when the volume tween finishes
func _on_volume_tween_finished() -> void:
	current_music_player.set_stream(current_track.music_clip)
	current_music_player.play(next_music_player.get_playback_position())
	current_music_player.set_volume_db(music_volume)
	next_music_player.stop()
