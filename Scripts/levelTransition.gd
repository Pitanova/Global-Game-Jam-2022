extends ColorRect

export(String, FILE, "*.tscn") var next_scene_path

onready var anim_player := $AnimationPlayer

func _ready() -> void:
	anim_player.play_backwards("Fade_to_Black")

func transition_to(next_scene := next_scene_path) -> void:
	anim_player.play("Fade_to_Black")
	yield(anim_player, "animation_finished")
	get_tree().change_scene(next_scene)
