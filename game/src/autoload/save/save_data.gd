## Contains data about a particular save slot
class_name SaveData extends Resource

@export var high_scores: Dictionary[String, int] = {}

@export var first_bind: bool = false

enum SilkSkill {
	THREAD_STORM,
	CROSS_STITCH,
}

@export var acquired_silk_skills: Array[SilkSkill] = [
	SilkSkill.THREAD_STORM
]

@export var equipped_silk_skill: SilkSkill = SilkSkill.THREAD_STORM
