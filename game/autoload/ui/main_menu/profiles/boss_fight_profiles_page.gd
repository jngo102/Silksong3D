class_name BossFightProfilesPage extends Control

@export var profiles: Array[BossFightProfileData]

@onready var _elements: HBoxContainer = $Contents/Elements

var profile_scene: PackedScene = preload("uid://ckjwakw16sbpx")

func _ready() -> void:
	_create_profile_elements()

func _create_profile_elements() -> void:
	for profile in profiles:
		var profile_element: BossFightProfile = profile_scene.instantiate()
		profile_element.data = profile
		_elements.add_child(profile_element)

func _on_visibility_changed() -> void:
	if visible:
		for profile in _elements.get_children():
			if profile is BossFightProfile:
				await profile.show_profile()
		_elements.get_child(0).get_node_or_null("Thumbnail").grab_focus()

func _on_back_button_pressed() -> void:
	for profile in _elements.get_children():
		if profile is BossFightProfile:
			await profile.hide_profile()
	hide()
