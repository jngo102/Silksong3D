class_name HUD extends Control

@onready var _health_pieces: Control = $HealthPieces
@onready var _spool_chunks: Control = $Spool/Chunks
@onready var _target: TextureRect = $Target

var health_piece_scene: PackedScene = preload("uid://bnf2ejvq7yjwy")
var spool_chunk_scene: PackedScene = preload("uid://sl4ip8f7wcqj")

var _linked_player: Player

func _ready() -> void:
	_set_up_hud.call_deferred()

func _process(delta: float) -> void:
	_focus_target()

func _focus_target() -> void:
	if not is_instance_valid(_linked_player):
		return
	if is_instance_valid(_linked_player.target):
		_target.visible = true
		_target.position = get_viewport().get_camera_3d().unproject_position(_linked_player.targeter.global_position)
	else:
		_target.visible = false

func _set_up_hud() -> void:
	_link_player_components()
	_create_health_pieces()
	_create_spool_chunks()

func _link_player_components() -> void:
	_linked_player = get_tree().get_first_node_in_group("Players")

func _create_health_pieces() -> void:
	var health_index: int = 0
	for health in _linked_player.health.max_health:
		var health_piece: HealthPiece = health_piece_scene.instantiate()
		health_piece.health = _linked_player.health
		health_piece.health_index = health_index
		_health_pieces.add_child(health_piece)
		health_piece.position += Vector2.RIGHT * 72 * health_index
		health_index += 1
		await get_tree().create_timer(0.25, false).timeout

func _create_spool_chunks() -> void:
	var chunk_index: int = 0
	for chunk in _linked_player.spool_manager.max_silk:
		var spool_chunk: SpoolChunk = spool_chunk_scene.instantiate()
		spool_chunk.spool_manager = _linked_player.spool_manager
		spool_chunk.chunk_index = chunk_index
		_spool_chunks.add_child(spool_chunk)
		spool_chunk.position += Vector2.RIGHT * 12 * chunk_index
		chunk_index += 1
		await get_tree().create_timer(0.25, false).timeout
