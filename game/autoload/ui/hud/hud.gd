class_name HUD extends Control

@onready var _health_pieces: Control = $HealthPieces
@onready var _spool_chunks: Control = $Spool/Chunks

var health_piece_scene: PackedScene = preload("uid://bnf2ejvq7yjwy")
var spool_chunk_scene: PackedScene = preload("uid://sl4ip8f7wcqj")

var _linked_health: Health

func _ready() -> void:
	_set_up_hud.call_deferred()

func _set_up_hud() -> void:
	_link_player_health()
	_create_health_pieces()
	_create_spool_chunks()

func _link_player_health() -> void:
	var player: Player = get_tree().get_first_node_in_group("Players")
	_linked_health = player.health

func _create_health_pieces() -> void:
	var health_index: int = 0
	for health in _linked_health.max_health:
		var health_piece: HealthPiece = health_piece_scene.instantiate()
		health_piece.health = _linked_health
		health_piece.health_index = health_index
		_health_pieces.add_child(health_piece)
		health_piece.position += Vector2.RIGHT * 72 * health_index
		health_index += 1
		await get_tree().create_timer(0.25, false).timeout

func _create_spool_chunks() -> void:
	var chunk_index: int = 0
	for chunk in range(0, 8):
		var spool_chunk: SpoolChunk = spool_chunk_scene.instantiate()
		#spool_chunk.spool = _linked_spool
		spool_chunk.chunk_index = chunk_index
		_spool_chunks.add_child(spool_chunk)
		spool_chunk.position += Vector2.RIGHT * 12 * chunk_index
		chunk_index += 1
		await get_tree().create_timer(0.25, false).timeout
