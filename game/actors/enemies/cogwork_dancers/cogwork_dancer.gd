class_name CogworkDancer extends Enemy

@export var top: bool

@onready var model: Node3D = $Model
@onready var clasher: Area3D = model.get_node_or_null("Clasher")
@onready var clash_audio: AudioStreamPlayer3D = clasher.get_node_or_null("ClashAudio")
@onready var clash_light: OmniLight3D = clasher.get_node_or_null("ClashLight")

var bb: Blackboard:
	get:
		return behavior_tree.blackboard

func _ready() -> void:
	bb.set_var("top", top)
	if not top:
		model.scale.x *= -1

func _on_clasher_body_entered(body: Node3D) -> void:
	if body == self or body is not CogworkDancer or not bb.get_var(&"dashing", false):
		return
	clash_audio.play()
	create_tween().tween_property(clash_light, "light_energy", 0, 0.35).from(1024).set_trans(Tween.TRANS_LINEAR)
