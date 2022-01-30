extends CanvasLayer
onready var animation_player = $AnimationPlayer

func change_scene(path, delay = 0.5):
	yield(get_tree().create_timer(delay), "timeout")
	animation_player.play("fade_to_black")
	yield(animation_player, "animation_finished")
	animation_player.play_backwards("fade_to_black")
	get_tree().change_scene(path)

func player_died(delay = 0.5):
	yield(get_tree().create_timer(delay), "timeout")
	animation_player.play("fade_to_black")
	yield(animation_player, "animation_finished")
	animation_player.play_backwards("fade_to_black")	
	# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
